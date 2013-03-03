Usage
-----

Basic usage is:

~~~~
caq <vendor>/<project> [<profile>]
~~~~


This will create a project located in directory `./myzf2app` based 
on [ZendSkeletonApplication] with [ZendFramework] installed as [Composer] 
package in `./vendor/zendframework`:

~~~~
caq myvendor/myzf2app zf2-app
~~~~


This will create a project located in directory `./myzf2app` based 
on nothing (no skeleton application) with [ZendFramework] installed as 
[Composer] package in `./vendor/zendframework`, in other words, a project
with the pure framework, no application:

~~~~
caq myvendor/myzf2project zf2
~~~~


This will create a project located in directory `./mysymfonyproject` based 
on nothing (no skeleton application) with [Symfony] installed as [Composer] 
package in `./vendor/symfony`:

~~~~
caq myvendor/mysymfonyproject symfony
~~~~
