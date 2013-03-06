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





