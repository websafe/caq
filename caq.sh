#!/bin/bash
# caq - Composed Application Quickstarter
# =======================================
# 
# A simple [Bash] script for automated preparation of [Composer] based
# applications (i.e. [ZendFramework] apps).
# 
# 
# License
# -------
# 
# Copyright (c) 2013 Thomas Szteliga <ts@websafe.pl>, http://websafe.pl/
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
## -----------------------------------------------------------------------------
set -e
## -----------------------------------------------------------------------------
CMD_CP=${CMD_CP:-/usr/bin/cp}
CMD_CUT=${CMD_CUT:-/usr/bin/cut}
CMD_DIRNAME=${CMD_DIRNAME:-/usr/bin/dirname}
CMD_GIT=${CMD_GIT:-/usr/bin/git}
CMD_GREP=${CMD_GREP:-/usr/bin/grep}
CMD_MV=${CMD_MV:-/usr/bin/mv}
CMD_MKDIR=${CMD_MKDIR:-/usr/bin/mkdir}
CMD_PHP=${CMD_PHP:-/usr/bin/php}
CMD_PHP_OPT=${CMD_PHP_OPT:-}
CMD_REALPATH=${CMD_REALPATH:=/usr/bin/realpath}
CMD_RM=${CMD_RM:-/bin/rm}
CMD_SED=${CMD_SED:-/usr/bin/sed}
### ----------------------------------------------------------------------------
## Zend Skeleton Application git repository:
ZFSA_URI=${ZFSA_URI:-git://github.com/zendframework/ZendSkeletonApplication.git}
## This default helps with composer timeouts on slow connections
COMPOSER_PROCESS_TIMEOUT=${COMPOSER_PROCESS_TIMEOUT:-5000}
### ----------------------------------------------------------------------------
function extractContent() {
    local contentId=${1}
    ${CMD_GREP} -E "^### ${contentId}:" \
        ${SCRIPT_ABSPATH} | ${CMD_CUT} -d':' -f3-
}
### ----------------------------------------------------------------------------
##
##
##
if [ -z ${1} ]; then
    echo "Usage: ${0} <vendor>/<project>"
    exit 1;
else
    vendor=$(echo ${1} | ${CMD_CUT} -d'/' -f1)
    project=$(echo ${1} | ${CMD_CUT} -d'/' -f2)
    homepage="https://github.com/${vendor}/${project}"
    license="MIT"
fi
### ----------------------------------------------------------------------------
SCRIPT_ABSDIR=$(${CMD_DIRNAME} $(${CMD_REALPATH} ${0}))
SCRIPT_ABSPATH=$(${CMD_REALPATH} ${0})
PROJECT_ABSPATH=$(${CMD_REALPATH} ${project})
### ----------------------------------------------------------------------------
##
## Check if project directory exists...
##
if [ -d ${PROJECT_ABSPATH} ];
then
    echo "Directory ${PROJECT_ABSPATH} exists! Choose another one."
    exit 2
else
    ##
    ## Clone Zend Skeleton Application into ${project} directory...
    ##
    if ${CMD_GIT} clone ${ZFSA_URI} ${PROJECT_ABSPATH};
    then
        ##
        cd ${PROJECT_ABSPATH}
        ##
        ## Cloned app contains composer.phar, often out-dated, so...
        ##
        if ${CMD_PHP} ./composer.phar -n selfupdate;
        then
            ##
            ## Create destination dir for vendor "binaries"...
            ##
            ${CMD_MKDIR} -p vendor/bin
            ##
            ## Move composer.phar to its final destination (vendor/bin)
            ##
            if ${CMD_MV} composer.phar vendor/bin/;
            then
                extractContent "CJSON:default" \
                    | ${CMD_SED} \
                        -e "s/PROJECT_VENDOR/${vendor}/g" \
                        -e "s/PROJECT_NAME/${project}/g" \
                        -e "s#PROJECT_HOMEPAGE#${homepage}#g" \
                        -e "s/PROJECT_KEYWORDS/${keywords}/g" \
                        -e "s/PROJECT_LICENSE/${license}/g" \
                    > composer.json
                ${CMD_PHP} vendor/bin/composer.phar config process-timeout 5000
                #${CMD_PHP} vendor/bin/composer.phar -n update
                ##
                ## Install dependencies found at the end of this file
                ## in lines starting with '## COMPOSERDEPS:default:'
                ##
                for dep in $(
                        extractContent "COMPOSERDEPS:default" \
                            | ${CMD_CUT} -d' ' -f1
                    );
                do
                    ##
                    ## Install dependency (composer.json gets updated too):
                    ##
                    ${CMD_PHP} vendor/bin/composer.phar \
                        require -n "${dep}"
                done
            else
                echo "Problem while moving composer to its final destination."
                exit 3;
            fi
        else
            echo "Problem while self-updating composer."
            exit 4;
        fi
    else
        echo "Problem while cloning Zend Skeleton Application."
        exit 5;
    fi
fi
##
## Remove git data of ZendSkeletonApplication
##
${CMD_RM} -rf ${PROJECT_ABSPATH}/.git
##
##
##
##
### ----------------------------------------------------------------------------
### COMPOSERDEPS:default:zendframework/zendframework:2.1.3
### COMPOSERDEPS:default:zendframework/zend-developer-tools:*
### COMPOSERDEPS:default:zf-commons/zfc-user:*
### COMPOSERDEPS:default:zendframework/zendpdf:*
### COMPOSERDEPS:default:fabpot/PHP-CS-Fixer:*
### COMPOSERDEPS:default:squizlabs/PHP_CodeSniffer:*
### COMPOSERDEPS:default:phpunit/PHPUnit:3.7.*
### COMPOSERDEPS:default:phpunit/php-invoker:*
### COMPOSERDEPS:default:doctrine/common:*
### COMPOSERDEPS:default:doctrine/doctrine-orm-module:*
### COMPOSERDEPS:default:doctrine/phpcr-odm:*
### COMPOSERDEPS:default:doctrine/data-fixtures:*
### COMPOSERDEPS:default:doctrine/migrations:*
### COMPOSERDEPS:default:symfony/yaml:*
### COMPOSERDEPS:default:bjyoungblood/bjy-profiler:*
### COMPOSERDEPS:default:phpdocumentor/phpdocumentor:*
## And a few not working (## not ### so will be ignored)
## zfc-base will be automatically installed by zfc-user
## COMPOSERDEPS:default:zf-commons/zfc-base:*
## suggested by zendframework but not available yet? 
## COMPOSERDEPS:default:zendframework/zendservice-recaptcha:*
## no mongo support on my machine ;>
## COMPOSERDEPS:default:doctrine/mongodb-odm:*
## -----------------------------------------------------------------------------
### CJSON:default:{
### CJSON:default:    "name": "PROJECT_VENDOR/PROJECT_NAME",
### CJSON:default:    "description": "PROJECT_DESCRIPTION",
### CJSON:default:    "license": "PROJECT_LICENSE",
### CJSON:default:    "keywords": [
### CJSON:default:        PROJECT_KEYWORDS
### CJSON:default:    ],
### CJSON:default:    "homepage": "PROJECT_HOMEPAGE",
### CJSON:default:    "require": {
### CJSON:default:        "php": ">=5.3.3"
### CJSON:default:    },
### CJSON:default:    "minimum-stability": "dev"
### CJSON:default:}
## -----------------------------------------------------------------------------
## EOF