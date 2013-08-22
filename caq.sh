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
CMD_CAT=${CMD_CAT:-/usr/bin/cat}
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
    if [ ! -r ${PROJECT_ABSPATH}/LICENSE ]; then
        if [ -r ${PROJECT_ABSPATH}/LICENSE.txt ]; then
            ${CMD_MV} ${PROJECT_ABSPATH}/LICENSE.txt \
                ${PROJECT_ABSPATH}/LICENSE
        elif [ -r ${PROJECT_ABSPATH}/license.txt ]; then
            ${CMD_MV} ${PROJECT_ABSPATH}/license.txt \
                ${PROJECT_ABSPATH}/LICENSE
        fi
    fi
    if [ ! -r ${PROJECT_ABSPATH}/LICENSE ]; then
        ##
        ## Put default license
        ##
        extractContent "LT:MIT" > ${PROJECT_ABSPATH}/LICENSE
    fi
    ##
    ## GIT
    ##
    (
        cd ${PROJECT_ABSPATH};
        ${CMD_GIT} add LICENSE;
        ${CMD_GIT} commit LICENSE \
            -m "[caq] Added initial 'LICENSE'.";
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
            ## Move composer.json found in skeleton (if)
            ##
            if [ -r composer.json ]; then
            ${CMD_MV} composer.json composer.json.orig
            fi
            ##
            ## If there was a composer.phar left by Skeleton Application, remove it
            ##
            if [ -r composer.phar ]; then
            ${CMD_RM} composer.phar
            fi
            ##
            ##
            ##
            if [ ! -r composer.json ]; then
                echo "No initial 'composer.json' found. Creating from template."
                extractContent "CJ:default" \
                    | ${CMD_SED} \
                        -e "s/PROJECT_VENDOR/${vendor}/g" \
                        -e "s/PROJECT_NAME/${project}/g" \
                        -e "s#PROJECT_HOMEPAGE#${homepage}#g" \
                        -e "s/PROJECT_KEYWORDS/${keywords}/g" \
                        -e "s/PROJECT_LICENSE/${license}/g" \
                   > composer.json
            else
                echo "Found 'composer.json' in skeleton, updating name..."
                ${CMD_CAT} composer.json
                ${CMD_CAT} composer.json \
                    | ${CMD_SED} \
                        -e "s/\"name\":.*,/\"name\": \"${vendor}\/${project}\",/g" \
                    > composer.json.tmp
                cat composer.json.tmp
                ${CMD_MV} composer.json.tmp composer.json
            fi
            ${CMD_CAT} composer.json
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
            ## ----------------------------------------------------------------
            ##
            ##
            ##     Installing [Composer] packages for current profile. (DEV)
            ##
            ##
            ## -----------------------------------------------------------------
            for dep in $(
                    ## extract profile data (located at the bottom of this file.
                    extractContent "PKGD:${CURRENT_PROFILE}" \
                        | ${CMD_CUT} -d' ' -f1
                );
            do
                echo "Starting installation of package ${dep}..."
                ## Install dependency (composer.json gets updated too):
                if ${CMD_PHP} vendor/bin/composer.phar \
                    require --dev -n "${dep}";
                then
                    echo "Installation of package ${dep} has finished."
                    ##
                    ## GIT
                    ##
                    ${CMD_GIT} commit composer.json \
                        -m "[caq] Added [Composer] dev-package ${dep}."
                else
                    echo "Problem while installing ${dep}"
                    exit 5;
                fi
            done
            ##
            ##
            ##
            ${CMD_PHP} vendor/bin/composer.phar dumpautoload
            ##
            ## GIT
            ##
            ${CMD_GIT} branch develop;
            ${CMD_GIT} checkout develop;
            ${CMD_GIT} branch;
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
### [CakePHP] based project.
###
### PROFILE:cakephp
### SA:cakephp:git://github.com/cakephp/cakephp.git
###
###
###
### caq
###
### PROFILE:caq
### SA:caq:git://github.com/websafe/caq.git
###
###
###
### [CodeIgniter] based project.
###
### PROFILE:codeigniter
### SA:codeigniter:git://github.com/EllisLab/CodeIgniter.git
###
###
###
### [Drupal] based project.
###
### PROFILE:drupal
### SA:drupal:git://github.com/drupal/drupal.git
###
###
###
### Empty project with [DirectAdmin API PHP class] in `./vendor/`.
###
### PROFILE:empty-directadmin
### PKG:empty-directadmin:directadmin/directadmin:dev-master
###
###
###
### Empty project with [Dropbox SDK for PHP] in `./vendor/`.
###
### PROFILE:empty-dropbox-sdk-php
### PKG:empty-dropbox-sdk-php:dropbox/dropbox-sdk:dev-master
###
###
###
### Empty project with [Facebook PHP SDK] in `./vendor/`.
###
### PROFILE:empty-facebook-php-sdk
### PKG:empty-facebook-php-sdk:facebook/php-sdk:*
###
###
###
### Empty project with [AdWords PHP API Client] in `./vendor/`.
###
### PROFILE:empty-google-adwords-api
### PKG:empty-google-adwords-api: google/adwords:dev-master
###
###
###
### Empty project with [PHP Client for Google APIs] in `./vendor/`.
###
### PROFILE:empty-google-api-client
### PKG:empty-google-api-client:google/api-client:dev-master
###
###
###
### Empty project with jQuery in `./vendor/`.
###
### PROFILE:empty-jquery
### PKG:empty-jquery:frameworks/jquery:*
###
###
###
### Empty project with [Laravel] in `./vendor/`.
###
### PROFILE:empty-laravel
### PKG:empty-laravel:laravel/laravel:dev-master
###
###
###
### Empty project with [Michelf PHP Markdown] library in `./vendor/`.
###
### PROFILE:empty-michelf-php-markdown
### PKG:empty-michelf-php-markdown:michelf/php-markdown:dev-master
###
###
###
### An empty project with [Symfony Framework] libraries.
###
### PROFILE:empty-symfony
### PKG:empty-symfony:symfony/symfony:dev-master
###
###
###
### Empty project with Twitter Bootstap and [Zenf Framework 2] libraries in `./vendor/`.
###
### PROFILE:empty-twitter-bootstrap-zf2
### PKG:empty-twitter-bootstrap-zf2:twitter/bootstrap:*
### PKG:empty-twitter-bootstrap-zf2:zendframework/zendframework:2.2.*
###
###
###
### Empty project with Twitter Bootstap in `./vendor/`.
###
### PROFILE:empty-twitter-bootstrap
### PKG:empty-twitter-bootstrap:twitter/bootstrap:*
###
###
###
### Empty project with [WP-CLI] (a command line interface for WordPress) in `./vendor/`.
###
### PROFILE:empty-wp-cli
### PKG:empty-wp-cli:wp-cli/wp-cli:dev-master
###
###
###
### An empty project with [ZendFramework 2] libraries in `vendors/`.
###
### PROFILE:empty-zendframework
### PKG:empty-zendframework:zendframework/zendframework:2.2.*
###
###
###
### An empty project with [ZendFramework 1] libraries in `vendors/`.
###
### PROFILE:empty-zendframework1
### PKG:empty-zendframework1:zendframework/zendframework1:dev-master
###
###
###
### Empty project with [ZendFramework 2] libraries in `vendors/`.
###
### PROFILE:empty-zf2
### PKG:empty-zf2:zendframework/zendframework:2.2.*
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
### An empty project with [Twig] libraries.
###
### PROFILE:empty-twig
### PKG:empy-twig:twig/twig:dev-master
###
###
###
### [Joomla] based project.
###
### PROFILE:joomla
### SA:joomla:git://github.com/joomla/joomla-cms.git
###
###
###
### [Kohana PHP Framework] based project.
###
### PROFILE:kohana
### SA:kohana:git://github.com/kohana/kohana.git
###
###
###
### Symfony Standard Edition - a fully-functional Symfony2
### application that you can use as the skeleton for your new
### applications.
###
### PROFILE:symfony-standard
### SA:symfony-standard:git://github.com/symfony/symfony-standard.git
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
### A [ZendSkeletonApplication] based project with [ZendFramework 2] libraries and lot of useful deps in `vendors/`.
###
### PROFILE:zf2app-full
### SA:zf2app-full:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2app-full:zendframework/zendframework:2.2.*
### PKG:zf2app-full:zf-commons/zfc-user:*
### PKG:zf2app-full:zendframework/zendpdf:*
### PKG:zf2app-full:doctrine/common:*
### PKG:zf2app-full:doctrine/doctrine-orm-module:*
### #PKG:doctrine/phpcr-odm:*
### PKG:zf2app-full:doctrine/data-fixtures:*
### PKG:zf2app-full:doctrine/migrations:*
### PKG:zf2app-full:symfony/yaml:*
### PKGD:zf2app-full:zendframework/zend-developer-tools:*
### PKGD:zf2app-full:fabpot/PHP-CS-Fixer:*
### PKGD:zf2app-full:squizlabs/PHP_CodeSniffer:*
### PKGD:zf2app-full:phpunit/PHPUnit:3.7.*
### PKGD:zf2app-full:phpunit/php-invoker:*
### PKGD:zf2app-full:bjyoungblood/bjy-profiler:*
### PKGD:zf2app-full:phpdocumentor/phpdocumentor:*
###
###
###
### A [ZendSkeletonApplication] based project with [ZfcUser] module and [ZendFramework 2] libraries in `vendors/`.
###
### PROFILE:zf2app-zfc-user
### SA:zf2app-zfc-user:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2app-zfc-user:zendframework/zendframework:2.2.*
### PKG:zf2app-zfc-user:zf-commons/zfc-user:*
###
###
###
### A [ZendSkeletonApplication] based project with [ZendFramework 2] libraries in `vendors/`.
###
### PROFILE:zf2app
### SA:zf2app:git://github.com/zendframework/ZendSkeletonApplication.git
### PKG:zf2app:zendframework/zendframework:2.2.*
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