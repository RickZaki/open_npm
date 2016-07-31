# open_npm

An example repos displaying a typical open source workflow for node projects distributed via NPM


### Repos set-up
The master branch has been forked to develop.  
The develop branch has been set as the default.  
Both master & develop have been protected.  
Pull Request should be opened against develop, and master should represent the most current release.


### Travis
With every push a travis build is fired.  
The promote script is configured to exit if not in develop branch.  
Travis will deploy the final package to npmjs.  


### Promote Script
The script only runs against the develop branch.  
The script:
  1. merges the changes from develop into master
  2. updates the package version number
  3. pushes the changes to master for Travis to build
  4. merges the changes from master back into develop so develop is the most recent
  5. pushes the changes to back to github
   