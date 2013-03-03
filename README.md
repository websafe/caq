caq - Composed Application Quickstarter
=======================================

A simple [Bash] script for automated preparation of [Composer] based
applications (i.e. [ZendFramework] apps).


License
-------

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


Installation
------------

~~~~
wget -nc \
    https://raw.github.com/websafe/caq/caq.sh \
    -O /usr/bin/caq
chmod +x /usr/bin/caq
~~~~


`-ns` stands for `--no-clobber`:

>  -nc, --no-clobber              skip downloads that would download to
>                                 existing files (overwriting them).


Usage
-----

~~~~
caq myvendor/myapplication
~~~~

will create a folder `myapplication` in the current directory and initiate
a default set of dependencies (currently hardoced, will change soon).


Contributing
------------

 + Start using [caq]!
 + [Report issues]
 + [Request features]



Requirements
------------

 + [Bash]
 + [Composer]
 + [Git]
 + [grep]
 + [PHP]
 + [sed]


TODO
----

 + User configs profiles in ~/.caq/
 + User templates for faster creation of projects (stored in ~/.caq/templates)
 + Plugins


[Bash]: http://www.gnu.org/software/bash/bash.html
[Composer]: http://getcomposer.org/
[ZendFramework]: http://framework.zend.com/
[ZendSkeletonApplication]: https://github.com/zendframework/ZendSkeletonApplication
[Git]: http://git-scm.com/
[GitHub]: https://github.com/
[grep]: http://www.gnu.org/software/grep/
[PHP]: http://php.net/
[sed]: http://www.gnu.org/software/sed/
[caq]: https://github.com/websafe/caq/
[Report issues]: https://github.com/websafe/caq/issues
[Request features]: https://github.com/websafe/caq/issues?labels=enhancement&page=1&state=open

