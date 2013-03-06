caq - Composed Application Quickstarter
================================================================================

A simple [Bash] script for automated preparation of [Composer] based
applications (i.e. [ZendFramework] apps).


Installation
--------------------------------------------------------------------------------

### General installation procedure

Only `caq.sh`(https://raw.github.com/websafe/caq/master/caq.sh) is really
required, download it into a location available via PATH and make it executable.
That's all.


### Install using [PHP]

~~~~
php -r \
    "copy('https://raw.github.com/websafe/caq/master/caq.sh', '/usr/bin/caq');"
chmod +x /usr/bin/caq
~~~~


### Install using [GNU Wget]

~~~~
wget -nc \
    https://raw.github.com/websafe/caq/master/caq.sh \
    -O /usr/bin/caq
chmod +x /usr/bin/caq
~~~~


`-ns` stands for `--no-clobber`:

>  -nc, --no-clobber              skip downloads that would download to
>                                 existing files (overwriting them).


### Install using [Lynx]

~~~~
lynx -dump \
    https://raw.github.com/websafe/caq/master/caq.sh \
    > /usr/bin/caq
chmod +x /usr/bin/caq
~~~~


Usage
--------------------------------------------------------------------------------


### Basic usage

Basic usage is:

~~~~
caq <vendor>/<project> <profile>
~~~~



### Example 1. A [ZendSkeletonApplication] based project with [ZendFramework]

This will create a project located in directory `./my-example-1` based 
on [ZendSkeletonApplication] with [ZendFramework] installed as a [Composer]
package in `./vendor/zendframework`:

~~~~
caq myvendor/my-example-1 zf2-app
~~~~



### Example 2. An empty project with [ZendFramework] libraries

This will create a project located in directory `./my-example-2` based 
on nothing (no skeleton application) with [ZendFramework] installed as a
[Composer] package in `./vendor/zendframework`, in other words, a project
with the pure framework, no application:

~~~~
caq myvendor/my-example-2 zf2
~~~~



### Example 3. A [Symfony Standard Edition] based project.

This will create a project located in directory `./my-example-3` based 
on the [Symfony Standard Edition] skeleton:

~~~~
caq myvendor/my-example-3 symfony-standard
~~~~



### Example 4. An empty project with [Symfony] libraries

This will create a project located in directory `./my-example-4` based 
on nothing (no skeleton application) with [Symfony] installed as [Composer] 
package in `./vendor/symfony`:

~~~~
caq myvendor/my-example-4 symfony
~~~~



### Example 5. A [WordPress] based project

This will create a project located in directory `./my-example-5` based 
on [WordPress]:

~~~~
caq myvendor/my-example-5 wordpress
~~~~



### Example 6. A [ZendSkeletonApplication] based project with [ZendFramework] libraries and [ZfcUser] module  

This will create a project located in directory `./my-example-6` based 
on [ZendSkeletonApplication] with [ZendFramework] installed as a [Composer]
package in `./vendor/zendframework/zendframework` and [ZfcUser] module installed
as a [Composer] package in `./vendor/zf-commons/zfc-user`:

~~~~
caq myvendor/my-example-6 zf2-app-zfc-user
~~~~



### Example 7. An empty project with [Twig] libraries. 

This will create an empty project located in directory `./my-example-7`
with [Twig] libraries installed as a [Composer] package in `./vendor/twig/twig`:

~~~~
caq myvendor/my-example-7 twig
~~~~






Contributing
--------------------------------------------------------------------------------

 + Start using [caq]!
 + [Report issues]
 + [Request features]
 + Read
   [14 Ways to Contribute to Open Source without Being a Programming Genius]


Requirements
--------------------------------------------------------------------------------

 + [Bash]
 + [Composer]
 + [Git]
 + [grep]
 + [PHP]
 + [GNU sed]


TODO
--------------------------------------------------------------------------------

 + create documentation describing [Profiles]
 + classmap_generator after installing deps
 + User configs profiles in ~/.caq/
 + User templates for faster creation of projects (stored in ~/.caq/templates)
 + Plugins
 + Profiles testsuite
 + travis
 + testprofiles - with/without skeleton, with/without packages, emtpy, etc.
 + Windows/Cygwin compatible


How caq works
--------------------------------------------------------------------------------

### The basic procedure

**THIS SECTION IS INCOMPLETE**

 1.	If there is a [Skeleton Application] URI configured, try to clone this
	repo into projects root directory.
	If no skeleton URI was configured, skip to next step.

 2.	Install [Composer] in vendor/bin of projects root directory.

 3.	Selfupdate the previously installed [Composer]

 4.	Install all packages ([Composer] packages) configured for the current
	Profile. If no packages were defined, skip to next step.


Basically, when You don't define a Skeleton Application URI (SA)
and don't define any packages (PKG) You'll end up with an empty
project, containing:


~~~~
 + project-name
   + vendor
     + bin
       + composer.phar
     + composer
       + ClassLoader.php
       + autoload_classmap.php
       + autoload_namespaces.php
       + autoload_real.php
     + autoload.php
     + .gitignore
   + .gitignore
   + composer.json
   + README.md
   + LICENSE.md
~~~~


License
--------------------------------------------------------------------------------

caq - Composed Application Quickstarter (https://github.com/websafe/caq/)

Copyright (c) 2013 Thomas Szteliga <ts@websafe.pl>, http://websafe.pl/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



Links
--------------------------------------------------------------------------------

 + [14 Ways to Contribute to Open Source without Being a Programming Genius] - 
 + [Bash] - Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh).
 + [Composer] - Dependency Manager for PHP
 + [GNU Wget] - A free software package for retrieving files using HTTP, HTTPS and FTP, the most widely-used Internet protocols. It is a non-interactive commandline tool, so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc.
 + [GNU sed] - A Unix utility that parses text and implements a programming language which can apply transformations to such text.
 + [GitHub] - Online project hosting using Git.
 + [Git] - A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
 + [Lynx] - Lynx is a highly configurable text-based web browser for use on cursor-addressable character cell terminals.
 + [PHPUnit] - The PHP Unit Testing framework
 + [PHP] - A widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.
 + [Report issues] - Caq - Report issues
 + [Request features] - Caq - Request features
 + [Symfony Standard Edition] - The 'Symfony Standard Edition' distribution
 + [Symfony] - The Symfony PHP framework
 + [Twig] - Twig, the flexible, fast, and secure template language for PHP
 + [Wiki] - Caq Wiki
 + [WordPress] - Blog Tool, Publishing Platform and CMS
 + [ZendFramework] - Framework for modern high-performing PHP applications
 + [ZendSkeletonApplication] - Sample application skeleton using the ZF2 MVC layer
 + [ZfcUser] - A generic user registration and authentication module for ZF2. Supports Zend\Db and Doctrine2.
 + [caq] - caq - Composed Application Quickstarter
 + [grep] - Grep is a command-line utility for searching plain-text data sets for lines matching a regular expression.
 + [phpDocumentor] - Documentation Generator for PHP


[Bash]: http://www.gnu.org/software/bash/bash.html "Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)."
[Composer]: http://getcomposer.org/ "Dependency Manager for PHP"
[ZendFramework]: http://framework.zend.com/ "Framework for modern high-performing PHP applications"
[Git]: http://git-scm.com/ "A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency."
[GitHub]: https://github.com/ "Online project hosting using Git."
[grep]: http://www.gnu.org/software/grep/ "Grep is a command-line utility for searching plain-text data sets for lines matching a regular expression."
[GNU Wget]: http://www.gnu.org/software/wget/ "A free software package for retrieving files using HTTP, HTTPS and FTP, the most widely-used Internet protocols. It is a non-interactive commandline tool, so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc."
[Lynx]: http://lynx.isc.org/ "Lynx is a highly configurable text-based web browser for use on cursor-addressable character cell terminals."
[PHP]: http://php.net/ "A widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
[GNU sed]: http://www.gnu.org/software/sed/ "A Unix utility that parses text and implements a programming language which can apply transformations to such text."
[caq]: http://websafe.github.com/caq/ "caq - Composed Application Quickstarter"
[Report issues]: https://github.com/websafe/caq/issues "Caq - Report issues"
[Request features]: https://github.com/websafe/caq/issues?labels=enhancement&page=1&state=open "Caq - Request features"
[Wiki]: https://github.com/websafe/caq/wiki/ "Caq Wiki"
[Symfony]: http://symfony.com/ "The Symfony PHP framework"
[14 Ways to Contribute to Open Source without Being a Programming Genius]: http://blog.smartbear.com/software-quality/bid/167051/14-Ways-to-Contribute-to-Open-Source-without-Being-a-Programming-Genius-or-a-Rock-Star
[ZendSkeletonApplication]: https://github.com/zendframework/ZendSkeletonApplication "Sample application skeleton using the ZF2 MVC layer"
[WordPress]: https://github.com/WordPress/WordPress "Blog Tool, Publishing Platform and CMS"
[phpDocumentor]: http://www.phpdoc.org/ "Documentation Generator for PHP"
[PHPUnit]: https://github.com/sebastianbergmann/phpunit/ "The PHP Unit Testing framework"
[ZfcUser]: https://github.com/ZF-Commons/ZfcUser "A generic user registration and authentication module for ZF2. Supports Zend\Db and Doctrine2."
[Symfony Standard Edition]: https://github.com/symfony/symfony-standard "The 'Symfony Standard Edition' distribution"
[Twig]: https://github.com/fabpot/Twig "Twig, the flexible, fast, and secure template language for PHP"
