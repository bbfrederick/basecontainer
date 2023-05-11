# Release history

## Version 0.1.7 (5/11/23)
* Updated to miniconda py310_23.3.1-0.

## Version 0.1.6 (2/14/23)
* Moved the majority of the scientific libraries into basecontainer.
* Updated to miniconda py310_23.1.0-1.
* Updated to new github docker build action.
* Nailed down pyqtgraph to <0.13 to avoid some breaking changes in other packages.
* Got pyqt working again by moving library reinstalls to the end of the build.

## Version 0.1.5 (2/8/23)
* Fixed some new mamba build order issues.
* Updated the build action to fix a deprecated method of getting the version.

## Version 0.1.4 (2/8/23)
* Merged pull requests from dependabot.

## Version 0.1.3 (10/13/22)
* Remove some dead code from Dockerfile.
* Used a hack to fix the "urllib3 doesn't match" error during build.

## Version 0.1.2 (10/12/22)
* Do some cleanup before exiting.
* Use bash as the shell.

## Version 0.1.1 (10/6/22)
* Converted back to mamba, moved pyqt installation to basecontainer.  Works on both architectures now.

## Version 0.1.0 (10/6/22)
* Moved apt-get clean after the last install so we don't have to reload things.

## Version 0.0.9 (10/6/22)
* Convert to system python and pip for installation.  Mamba is just too slow.

## Version 0.0.8 (10/6/22)
* Added dependabot, updated a lot of script and container dependencies.

## Version 0.0.7 (10/5/22)
* Moved time zone setting to the beginning to avoid feedback requirement

## Version 0.0.6 (10/5/22)
* Added AWS access libraries 
* Updated README

## Version 0.0.5 (10/5/22)
* Now support multiarch builds (amd64 and arm64)

## Version 0.0.4 (8/31/22)
* Trying to force a recent mamba version

## Version 0.0.3 (8/31/22)
* Tweaked mamba installation again

## Version 0.0.2 (8/31/22)
* Tweaked mamba installation

## Version 0.0.1 (8/31/22)
* Initial commmit
