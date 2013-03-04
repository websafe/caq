Usage
--------------------------------------------------------------------------------

### Basic usage

Basic usage is:

~~~~
caq <vendor>/<project> [<profile>]
~~~~


### Example 1. A [ZendSkeletonAplication] based project with [ZendFramework] 

This will create a project located in directory `./myzf2app` based 
on [ZendSkeletonApplication] with [ZendFramework] installed as a [Composer]
package in `./vendor/zendframework`:

~~~~
caq myvendor/myzf2app zf2-app
~~~~


### Example 2. An empty project with [ZendFramework] libraries

This will create a project located in directory `./myzf2project` based 
on nothing (no skeleton application) with [ZendFramework] installed as a
[Composer] package in `./vendor/zendframework`, in other words, a project
with the pure framework, no application:

~~~~
caq myvendor/myzf2project zf2
~~~~


### Example 3. An empty project with [Symfony] libraries

This will create a project located in directory `./mysymfonyproject` based 
on nothing (no skeleton application) with [Symfony] installed as [Composer] 
package in `./vendor/symfony`:

~~~~
caq myvendor/mysymfonyproject symfony
~~~~


### Example 4. A [WordPress] based project

This will create a project located in directory `./mywordpressproject` based 
on [WordPress]:

~~~~
caq myvendor/mywordpressproject wordpress
~~~~


