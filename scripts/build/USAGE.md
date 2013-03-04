Usage
--------------------------------------------------------------------------------

### Basic usage

Basic usage is:

~~~~
caq <vendor>/<project> <profile>
~~~~


### Example 1. A [ZendSkeletonAplication] based project with [ZendFramework] 

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


### Example 3. An empty project with [Symfony] libraries

This will create a project located in directory `./my-example-3` based 
on nothing (no skeleton application) with [Symfony] installed as [Composer] 
package in `./vendor/symfony`:

~~~~
caq myvendor/my-example-3 symfony
~~~~


### Example 4. A [WordPress] based project

This will create a project located in directory `./my-example-4` based 
on [WordPress]:

~~~~
caq myvendor/my-example-4 wordpress
~~~~


### Example 5. A [ZendSkeletonAplication] based project with [ZendFramework] libraries and [ZfcUser] module  

This will create a project located in directory `./my-example-5` based 
on [ZendSkeletonApplication] with [ZendFramework] installed as a [Composer]
package in `./vendor/zendframework/zendframework` and [ZfcUser] module installed
as a [Composer] package in `./vendor/zf-commons/zfc-user`:

~~~~
caq myvendor/my-example-5 zf2-app-zfc-user
~~~~


