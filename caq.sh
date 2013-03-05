#!/bin/bash
# caq - Composed Application Quickstarter (https://github.com/websafe/caq/)
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
CMD_SORT=${CMD_SORT:-/usr/bin/sort}
### ----------------------------------------------------------------------------
## This default helps with composer timeouts on slow connections
COMPOSER_PROCESS_TIMEOUT=${COMPOSER_PROCESS_TIMEOUT:-5000}
## Preparing for Profiles - the default profile is "zf2-app"
DEFAULT_PROFILE=${DEFAULT_PROFILE:-zf2-app}
CURRENT_PROFILE=${CURRENT_PROFILE:-$DEFAULT_PROFILE}
### ----------------------------------------------------------------------------
SCRIPT_ABSDIR=$(${CMD_DIRNAME} $(${CMD_REALPATH} ${0}))
SCRIPT_ABSPATH=$(${CMD_REALPATH} ${0})
### ----------------------------------------------------------------------------
function extractContent() {
    local contentId=${1}
    ${CMD_GREP} -E "^### ${contentId}:" \
        ${SCRIPT_ABSPATH} | ${CMD_CUT} -d':' -f3-
}
function extractProfiles() {
    ${CMD_GREP} -E "^### PROFILE:" \
        ${SCRIPT_ABSPATH} \
        | ${CMD_CUT} -d':' -f2 \
        | ${CMD_SORT} -u
}
### ----------------------------------------------------------------------------
##
##
##
if [ -z ${1} ]; then
    echo "Usage: ${0} <vendor>/<project> <profile>"
    echo ""
    echo "Available profiles: "
    extractProfiles | ${CMD_SED} -e "s/^/ + /g"
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
PROJECT_ABSPATH=$(${CMD_REALPATH} ${project})
### ----------------------------------------------------------------------------
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
        ##
        ## GIT
        ##
        ${CMD_GIT} init ${PROJECT_ABSPATH}
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
            ## Remove vendor/ZF2 directory created if SA was ZendSkeletonApp...
            ##
            ${CMD_RM} -rf ${PROJECT_ABSPATH}/vendor/ZF2
            ##
            ##
            ##
            ${CMD_GIT} init ${PROJECT_ABSPATH}
        else
            echo "Problem while cloning Skeleton Application."
            exit 5;
        fi
    fi
    echo "Cloning Skeleton Application finished."
    ##
    ## Tricky licenses
    ##
    if [ ! -r ${PROJECT_ABSPATH}/LICENSE.md ]; then
        if [ -r ${PROJECT_ABSPATH}/LICENSE.txt ]; then
            ${CMD_MV} ${PROJECT_ABSPATH}/LICENSE.txt \
        ${PROJECT_ABSPATH}/LICENSE.md
    elif [ -r ${PROJECT_ABSPATH}/LICENSE ]; then
        ${CMD_MV} ${PROJECT_ABSPATH}/LICENSE \
        ${PROJECT_ABSPATH}/LICENSE.md
    fi
    fi
    if [ ! -r ${PROJECT_ABSPATH}/LICENSE.md ]; then
    ##
    ## Put default license
    ##
    extractContent "LT:MIT" > ${PROJECT_ABSPATH}/LICENSE.md
    fi
    ##
    ## GIT
    ##
    (
    cd ${PROJECT_ABSPATH};
    ${CMD_GIT} add LICENSE.md;
        ${CMD_GIT} commit LICENSE.md \
        -m "[caq] Added initial 'LICENSE.md'.";
    )
    ##
    ## Tricky readme
    ##
    if [ ! -r ${PROJECT_ABSPATH}/README.md ]; then
        if [ -r ${PROJECT_ABSPATH}/REAMDE.txt ]; then
            ${CMD_MV} ${PROJECT_ABSPATH}/README.txt \
        ${PROJECT_ABSPATH}/README.md
    elif [ -r ${PROJECT_ABSPATH}/README ]; then
        ${CMD_MV} ${PROJECT_ABSPATH}/README \
        ${PROJECT_ABSPATH}/README.md
    fi
    fi
    if [ ! -r ${PROJECT_ABSPATH}/README.md ]; then
    ##
    ## Put default README
    ##
    echo ${project} > ${PROJECT_ABSPATH}/README.md
    echo -n "========================================" \
        >> ${PROJECT_ABSPATH}/README.md
    echo "========================================" \
        >> ${PROJECT_ABSPATH}/README.md
    fi
    ##
    ## GIT
    ##
    (
    cd ${PROJECT_ABSPATH};
    ${CMD_GIT} add README.md;
    ${CMD_GIT} commit README.md \
        -m "[caq] Added initial 'README.md'.";
    )
    ##
    ## Default gitignore
    ##
    if [ ! -r ${PROJECT_ABSPATH}/.gitignore ]; then
    extractContent "FT:default.gitignore" > ${PROJECT_ABSPATH}/.gitignore
    fi
    ##
    ## GIT
    ##
    (
    cd ${PROJECT_ABSPATH};
    ${CMD_GIT} add .gitignore;
    ${CMD_GIT} commit .gitignore \
        -m "[caq] Added initial '.gitignore'.";
    )
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
            ##
            ## GIT
            ##
            ${CMD_GIT} add composer.json
            ${CMD_GIT} commit composer.json \
            -m "[caq] Added initial 'composer.json'."
            ##
            ##
            ##
            ${CMD_PHP} vendor/bin/composer.phar config process-timeout 5000
            ##
            ## GIT
            ##
            ${CMD_GIT} commit composer.json \
            -m "[caq] Updated [Composer] config."
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
                    ##
                    ## GIT
                    ##
                    ${CMD_GIT} commit composer.json \
                        -m "[caq] Added [Composer] package ${dep}."
                else
                    echo "Problem while installing ${dep}"
                    exit 5;
                fi
            done
            ##
            ##
            ##
            ${CMD_PHP} vendor/bin/composer.phar dumpautoload
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
### CJ:default:    "minimum-stability": "dev",
### CJ:default:    "require": {
### CJ:default:        "php": ">=5.3.3"
### CJ:default:    }
### CJ:default:}
## -----------------------------------------------------------------------------
###
### caq
###
### PROFILE:caq
### SA:caq:git://github.com/websafe/caq.git
###
###
###
### Empty profile - results in an empty project with README.md, LICENSE.md,
### and [Composer] generated files.
###
### PROFILE:empty
###
###
###
### An empty project with [Symfony Framework] libraries.
###
### PROFILE:symfony
### SA:symfony:
### PKG:symfony:symfony/framework-standard-edition:2.1.x-dev
###
###
###
### An empty project with [Twig] libraries.
###
### PROFILE:twig
### SA:twig:
### PKG:twig:twig/twig:1.*
###
###
###
### Empty project with Twitter Bootstap and ZendFramework libraries in `./vendor/`.
###
### PROFILE:wbf-empty-tb-zf2
### SA:wbf-empty-tb-zf2:
### PKG:wbf-empty-tb-zf2:zendframework/zendframework:2.1.3
### PKG:wbf-empty-tb-zf2:twitter/bootstrap:*
###
###
###
### A [WordPress] based project.
###
### PROFILE:wordpress
### SA:wordpress:git://github.com/WordPress/WordPress.git
###
###
###
### A project based on [ZendSkeletonApplication] with [ZendFramework]
### libraries and lot of useful deps.
###
### PROFILE:zf2-app-full
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
###
###
###
### A project based on [ZendSkeletonApplication] with [ZfcUser] module.
###
### PROFILE:zf2-app-zfc-user
### SA:zf2-app-zfc-user:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2-app-zfc-user:zendframework/zendframework:2.1.3
### PKG:zf2-app-zfc-user:zf-commons/zfc-user:*
###
###
###
### A project based on [ZendSkeletonApplication] with [ZendFramework] libraries.
###
### PROFILE:zf2-app
### SA:zf2-app:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2-app:zendframework/zendframework:2.1.3
###
###
###
### Pure ZendFramework 2 project without Skeleton, only framework in vendors/.
###
### PROFILE:zf2
### SA:zf2:
### PKG:zf2:zendframework/zendframework:2.1.3
###
###
### LT:MIT:Copyright (c) <year> <copyright holders>
### LT:MIT:
### LT:MIT:Permission is hereby granted, free of charge, to any person obtaining a copy
### LT:MIT:of this software and associated documentation files (the "Software"), to deal
### LT:MIT:in the Software without restriction, including without limitation the rights
### LT:MIT:to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
### LT:MIT:copies of the Software, and to permit persons to whom the Software is
### LT:MIT:furnished to do so, subject to the following conditions:
### LT:MIT:
### LT:MIT:The above copyright notice and this permission notice shall be included in
### LT:MIT:all copies or substantial portions of the Software.
### LT:MIT:
### LT:MIT:THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
### LT:MIT:IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
### LT:MIT:FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
### LT:MIT:AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
### LT:MIT:LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
### LT:MIT:OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
### LT:MIT:THE SOFTWARE.
###
###
### FT:default.gitignore:nbproject
### FT:default.gitignore:._*
### FT:default.gitignore:.~lock.*
### FT:default.gitignore:.buildpath
### FT:default.gitignore:.DS_Store
### FT:default.gitignore:.idea
### FT:default.gitignore:.project
### FT:default.gitignore:.settings
### FT:default.gitignore:composer.lock
### FT:default.gitignore:vendor
###
###
### EOF