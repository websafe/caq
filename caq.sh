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
# 
## -----------------------------------------------------------------------------
set -e
## -----------------------------------------------------------------------------
CMD_CP=${CMD_CP:-/usr/bin/cp}
CMD_CURL=${CMD_CURL:-/usr/bin/curl}
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
## This default helps with composer timeouts on slow connections
COMPOSER_PROCESS_TIMEOUT=${COMPOSER_PROCESS_TIMEOUT:-5000}
## Preparing for Profiles - the default profile is "zf2-app"
DEFAULT_PROFILE=${DEFAULT_PROFILE:-zf2-app}
CURRENT_PROFILE=${CURRENT_PROFILE:-$DEFAULT_PROFILE}
### ----------------------------------------------------------------------------
##
##    
##
if [ -z ${1} ]; then
    echo "Usage: ${0} <vendor>/<project> <profile>"
    exit 1;
else
    vendor=$(echo ${1} | ${CMD_CUT} -d'/' -f1)
    project=$(echo ${1} | ${CMD_CUT} -d'/' -f2)
    homepage="https://github.com/${vendor}/${project}"
    license="MIT"
    if [ ! -z "${2}" ]; then
        CURRENT_PROFILE=${2}
    else
        CURRENT_PROFILE=${DEFAULT_PROFILE}
    fi
fi
### ----------------------------------------------------------------------------
SCRIPT_ABSDIR=$(${CMD_DIRNAME} $(${CMD_REALPATH} ${0}))
SCRIPT_ABSPATH=$(${CMD_REALPATH} ${0})
PROJECT_ABSPATH=$(${CMD_REALPATH} ${project})
### ----------------------------------------------------------------------------
function extractContent() {
    local contentId=${1}
    ${CMD_GREP} -E "^### ${contentId}:" \
        ${SCRIPT_ABSPATH} | ${CMD_CUT} -d':' -f3-
}
function getCurrentProfileVariable() {
    local variableName=${1}
    local profileName=${CURRENT_PROFILE}
    extractContent "${variableName}:${profileName}"
}
### ----------------------------------------------------------------------------
##
## Check if project directory exists...
##
if [ -d ${PROJECT_ABSPATH} ];
then
    echo "Directory ${PROJECT_ABSPATH} exists! Choose another one."
    exit 2
else
    ## -------------------------------------------------------------------------
    ##
    ##
    ##    Creating project directory.
    ##
    ##
    ## -------------------------------------------------------------------------
    ${CMD_MKDIR} ${PROJECT_ABSPATH}
    ## -------------------------------------------------------------------------
    ##
    ##
    ##    Cloning Skeleton Application if it's configured (non-empty)
    ##
    ##
    ## -------------------------------------------------------------------------
    SA_URI=$(getCurrentProfileVariable "SA");
    ##
    ## If SA (Skeleton Application Uri) is empty
    ##
    if [ -z "${SA_URI}" ];
    then
        echo "No skeleton for current profile.";
    else
        ##
        ## Clone Skeleton Application into ${project} directory...
        ##
        if ${CMD_GIT} clone ${SA_URI} ${PROJECT_ABSPATH};
        then
            ##
            ## Remove git data of Skeleton Application
            ##
            ${CMD_RM} -rf ${PROJECT_ABSPATH}/.git
            ##
            ## Remove .gitmodules created Skeleton Application
            ##
            ${CMD_RM} -rf ${PROJECT_ABSPATH}/.gitmodules
            ##
            ## Remove vendor/ZF2 firectory created if SA was ZendSkeletonApp...
            ##
            ${CMD_RM} -rf ${PROJECT_ABSPATH}/vendor/ZF2
        else
            echo "Problem while cloning Skeleton Application."
            exit 5;
        fi
    fi
    echo "Cloning Skeleton Application finished."
    ## -------------------------------------------------------------------------
    ##
    ##
    ##     Installing [Composer].
    ##
    ##
    ## -------------------------------------------------------------------------
    if [ ! -d ${PROJECT_ABSPATH}/vendor ]; then 
        ${CMD_MKDIR} ${PROJECT_ABSPATH}/vendor;
    fi
    if [ ! -d ${PROJECT_ABSPATH}/vendor/bin ]; then
        ${CMD_MKDIR} ${PROJECT_ABSPATH}/vendor/bin
    fi
    echo "Starting [Composer] installation..."
    if ${CMD_CURL} -s https://getcomposer.org/installer \
         | ${CMD_PHP} -- \
              -n \
              --install-dir="${PROJECT_ABSPATH}/vendor/bin";
    then
        echo "Installing [Composer] has finished."
        ##
        ## ---------------------------------------------------------------------
        ##
        ##
        ##     Switching to project directory.
        ##
        ##
        ## ---------------------------------------------------------------------
        cd ${PROJECT_ABSPATH}
        ## ---------------------------------------------------------------------
        ##
        ##
        ##     Self-updating [Composer].
        ##
        ##
        ## ---------------------------------------------------------------------
		echo "Starting [Composer] self-update..."
        if ${CMD_PHP} ./vendor/bin/composer.phar -n selfupdate;
        then
        	echo "[Composer] self-update has finished."
            ##
            ##
            ##
            extractContent "CJ:default" \
                | ${CMD_SED} \
                    -e "s/PROJECT_VENDOR/${vendor}/g" \
                    -e "s/PROJECT_NAME/${project}/g" \
                    -e "s#PROJECT_HOMEPAGE#${homepage}#g" \
                    -e "s/PROJECT_KEYWORDS/${keywords}/g" \
                    -e "s/PROJECT_LICENSE/${license}/g" \
                > composer.json
            ${CMD_PHP} vendor/bin/composer.phar config process-timeout 5000
            #${CMD_PHP} vendor/bin/composer.phar -n update
            ## ----------------------------------------------------------------
            ##
            ##
            ##     Installing [Composer] packages for current profile.
            ##
            ##
            ## -----------------------------------------------------------------
            for dep in $(
                    ## extract profile data (located at the bottom of this file.
                    extractContent "PKG:${CURRENT_PROFILE}" \
                        | ${CMD_CUT} -d' ' -f1
                );
            do
            	echo "Starting installation of package ${dep}..."
                ## Install dependency (composer.json gets updated too):
                if ${CMD_PHP} vendor/bin/composer.phar \
                    require -n "${dep}";
                then
                	echo "Installation of package ${dep} has finished."
                else
                    echo "Problem while installing ${dep}"
                    exit 5;
                fi
            done
        else
            echo "Problem while self-updating [Composer]."
            exit 4;
        fi
    else
        ##
        echo "Problem while installing [Composer]."
        exit 4;
    fi
fi
### ----------------------------------------------------------------------------
###
### caq
###
### PROFILE:caq:stability:stable
### SA:caq:git://github.com/websafe/caq.git
## -----------------------------------------------------------------------------
###
### Pure ZendFramework 2 project without Skeleton, only framework in vendors/.
###
### PROFILE:zf2:stability:stable
### SA:zf2:
### PKG:zf2:zendframework/zendframework:2.1.3
## -----------------------------------------------------------------------------
###
### ZendFramework 2 project with Skeleton Application.
###
### PROFILE:zf2-app:stability:stable
### SA:zf2-app:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2-app:zendframework/zendframework:2.1.3
## -----------------------------------------------------------------------------
###
### ZendFramework 2 project with Skeleton Application with and ZfcUser.
###
### PROFILE:zf2-app-zfc-user:stability:stable
### SA:zf2-app-zfc-user:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2-app-zfc-user:zendframework/zendframework:2.1.3
### PKG:zf2-app-zfc-user:zf-commons/zfc-user:*
## -----------------------------------------------------------------------------###
### ZendFramework 2 project with Skeleton Application and lot of useful deps
###
### PROFILE:zf2-app-full:stability:stable
### SA:zf2-app-full:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2-app-full:zendframework/zendframework:2.1.3
### PKG:zf2-app-full:zendframework/zend-developer-tools:*
### PKG:zf2-app-full:zf-commons/zfc-user:*
### PKG:zf2-app-full:zendframework/zendpdf:*
### PKG:zf2-app-full:fabpot/PHP-CS-Fixer:*
### PKG:zf2-app-full:squizlabs/PHP_CodeSniffer:*
### PKG:zf2-app-full:phpunit/PHPUnit:3.7.*
### PKG:zf2-app-full:phpunit/php-invoker:*
### PKG:zf2-app-full:doctrine/common:*
### PKG:zf2-app-full:doctrine/doctrine-orm-module:*
### PKG:zf2-app-full:doctrine/phpcr-odm:*
### PKG:zf2-app-full:doctrine/data-fixtures:*
### PKG:zf2-app-full:doctrine/migrations:*
### PKG:zf2-app-full:symfony/yaml:*
### PKG:zf2-app-full:bjyoungblood/bjy-profiler:*
### PKG:zf2-app-full:phpdocumentor/phpdocumentor:*
## -----------------------------------------------------------------------------
###
### Symfony Framework project.
###
### PROFILE:symfony:stability:stable
### SA:symfony:
### PKG:symfony:symfony/framework-standard-edition:2.1.x-dev
## -----------------------------------------------------------------------------
###
### Default template for composer.json.
###
### CJ:default:{
### CJ:default:    "name": "PROJECT_VENDOR/PROJECT_NAME",
### CJ:default:    "description": "PROJECT_DESCRIPTION",
### CJ:default:    "license": "PROJECT_LICENSE",
### CJ:default:    "keywords": [
### CJ:default:        PROJECT_KEYWORDS
### CJ:default:    ],
### CJ:default:    "homepage": "PROJECT_HOMEPAGE",
### CJ:default:    "require": {
### CJ:default:        "php": ">=5.3.3"
### CJ:default:    },
### CJ:default:    "minimum-stability": "dev"
### CJ:default:}
## -----------------------------------------------------------------------------
## EOF