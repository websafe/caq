How caq works
--------------------------------------------------------------------------------

### The basic procedure

    + If there is a [Skeleton Application] URI configured,
      try to clone this repo into projects root directory.
      If no skeleton URI was configured, skip to next step.

    + Install [Composer] in vendor/bin of projects root directory.

    + Selfupdate the previously installed [Composer]

    + Install all packages ([Composer] packages) configured for the current
      Profile. If no packages were defined, skip to next step.



Basically, when You don't define a Skeleton Application URI (SA)
and don't define any packages (PKG) You'll end up with an empty
project, containing:

 + <project>
   + vendor
     + bin
       + composer.phar
     .gitignore
   + .gitignore
   + composer.json
   + README.md
   + LICENSE.md
