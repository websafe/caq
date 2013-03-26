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



Examples
--------------------------------------------------------------------------------


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



### Example 8. A [Kohana PHP Framework] based project. 

This will create a [Kohana PHP Framework] based project located in directory `./my-example-8`:

~~~~
caq myvendor/my-example-8 kohana
~~~~


### Example 9. A [Drupal] based project.

This will create a [Drupal] based project located in directory `./my-example-9`:

~~~~
caq myvendor/my-example-9 drupal
~~~~



### Example 10. A [CodeIgniter] based project.

This will create a [CodeIgniter] based project located in directory `./my-example-10`:

~~~~
caq myvendor/my-example-10 codeigniter
~~~~



### Example 11. A [Joomla] based project.

This will create a [Joomla] based project located in directory `./my-example-11`:

~~~~
caq myvendor/my-example-11 joomla
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

 + profile for an empty project with [Twitter Bootstrap]
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
 + [CakePHP] - CakePHP is a rapid development framework for PHP which uses commonly known design patterns like Active Record, Association Data Mapping, Front Controller and MVC.
 + [caq] - caq - Composed Application Quickstarter
 + [CodeIgniter] - CodeIgniter is a proven, agile & open PHP web application framework with a small footprint. It is powering the next generation of web apps.
 + [CodeIgniter] - CodeIgniter is an Application Development Framework - a toolkit - for people who build web sites using PHP.
 + [Composer] - Dependency Manager for PHP
 + [Drupal] - Drupal is an open source content management platform powering millions of websites and applications.
 + [Git] - A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
 + [GitHub] - Online project hosting using Git.
 + [GNU sed] - A Unix utility that parses text and implements a programming language which can apply transformations to such text.
 + [GNU Wget] - A free software package for retrieving files using HTTP, HTTPS and FTP, the most widely-used Internet protocols. It is a non-interactive commandline tool, so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc.
 + [grep] - Grep is a command-line utility for searching plain-text data sets for lines matching a regular expression.
 + [Joomla] - Joomla is an award-winning content management system (CMS), which enables you to build Web sites and powerful online applications.
 + [Kohana PHP Framework] - An elegant HMVC PHP5 framework that provides a rich set of components for building web applications.
 + [Lynx] - Lynx is a highly configurable text-based web browser for use on cursor-addressable character cell terminals.
 + [PHP] - A widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.
 + [phpDocumentor] - Documentation Generator for PHP
 + [PHPUnit] - The PHP Unit Testing framework
 + [Report issues] - Caq - Report issues
 + [Request features] - Caq - Request features
 + [Symfony] - The Symfony PHP framework
 + [Symfony Standard Edition] - The 'Symfony Standard Edition' distribution
 + [Twig] - Twig, the flexible, fast, and secure template language for PHP
 + [Wiki] - Caq Wiki
 + [WordPress] - Blog Tool, Publishing Platform and CMS
 + [ZendFramework] - Framework for modern high-performing PHP applications
 + [ZendSkeletonApplication] - Sample application skeleton using the ZF2 MVC layer
 + [ZfcUser] - A generic user registration and authentication module for ZF2. Supports Zend\Db and Doctrine2.


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
[Kohana PHP Framework]: http://kohanaframework.org/ "An elegant HMVC PHP5 framework that provides a rich set of components for building web applications."
[CakePHP]: https://github.com/cakephp/cakephp "CakePHP is a rapid development framework for PHP which uses commonly known design patterns like Active Record, Association Data Mapping, Front Controller and MVC."
[CodeIgniter]: https://github.com/EllisLab/CodeIgniter "CodeIgniter is an Application Development Framework - a toolkit - for people who build web sites using PHP."
[Drupal]: http://drupal.org/ "Drupal is an open source content management platform powering millions of websites and applications."
[CodeIgniter]: http://ellislab.com/codeigniter "CodeIgniter is a proven, agile & open PHP web application framework with a small footprint. It is powering the next generation of web apps."
[Joomla]: http://www.joomla.org/ "Joomla is an award-winning content management system (CMS), which enables you to build Web sites and powerful online applications."
