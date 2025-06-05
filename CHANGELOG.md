# Release history

## Version 0.4.9 (6/5/25)
* Added sbom and provenance.
* Fixed mamba init section.
* Removed explicit python installation (it wsas downgrading base from 3.12.11).

## Version 0.4.8 (4/22/25)
* Rebuilt with current, rearranged installations, leaned harder into using uv for speed.

## Version 0.4.7 (3/19/25)
* Rebuilt with current bookworm container and debian libraries to mitigate more security vulnerabilities.

## Version 0.4.6 (3/4/25)
* Rebuilt with current bookworm container and debian libraries to mitigate several xorg-server vulnerabilities.

## Version 0.4.5 (1/29/25)
* Rebuilt with current debian libraries to mitigate CVE-2024-52533

## Version 0.4.4 (12/30/24)
* Updated to 3.12.8-bookworm to remove some security vulnerabilities.
* Install s3fs and awscli through pip to avoid installing the version of cryptography with the nasty security vulnerability.

## Version 0.4.3 (12/30/24)
* Change IN_DOCKER_CONTAINER to RUNNING_IN_CONTAINER.

## Version 0.4.2 (11/19/24)
* Added more detailed git version information inside the container.

## Version 0.4.1 (11/19/24)
* Updated to bookworm
* Reorganized build
* Use IN_DOCKER_CONTAINER to indicate Docker
* Some dependabot updates

## Version 0.4.0 (11/15/24)
* Fixed path, added procps now works as base for rapidtide (without FSL).

## Version 0.3.9 (11/13/24)
* Some improved cleanup, exit as root

## Version 0.3.8 (10/23/24)
* Converted to python:3.12-slim-bullseye base image from mamba forge.
* Use uv to install all python packages.
* Install mamba separately to support FSL installation in basecontainer_plus.
* Removed pyyaml.
* Reduced the image size significantly (almost 50%).

## Version 0.3.7 (7/8/24)
* Update certifi to 2024.7.4 or greater (security patch)

## Version 0.3.6 (6/12/24)
* Update to python 3.12.3

## Version 0.3.5 (4/25/24)
* Undid build stages, moved versioneer back to mamba.

## Version 0.3.4 (4/25/24)
* Moved versioneer installation to pip from mamba.

## Version 0.3.3 (4/25/24)
* Updated to python 3.11.8
* Removed pyfftw
* Tweaked free space

## Version 0.3.2 (2/18/24)
* Install pyarrow to resolve a dependency with pandas.
* Increment python version to 3.11.7

## Version 0.3.1 (12/11/23)
* Added caching to build.

## Version 0.3.0 (12/11/23)
* Add vim to container to facilitate debugging.

## Version 0.2.9.2 (12/7/23)
* Rebuild to pick up the new version of nda-tools.

## Version 0.2.9.1 (11/17/23)
* Added a "-y" to all mamba installs that didn't have them.

## Version 0.2.9 (11/16/23)
* Updated to the latest version of pyqtgraph (0.13.3) now that tidepool and picachooser have been updated.

## Version 0.2.8 (10/31/23)
* Added latest-release tag to latest release, to make rapidtide-cloud happy.

## Version 0.2.7 (10/25/23)
* Added nda-tools.

## Version 0.2.6 (10/24/23)
* Install s3fs and awscli through apt-get, rather than mamba.

## Version 0.2.5 (10/7/23)
* Added memory_profiler to the base installation.
* Update to python 3.11.6.

## Version 0.2.4 (10/4/23)
* Moved some long installs here from the rapidtide container.

## Version 0.2.3 (9/13/23)
* Mass merge of a bunch of dependabot PRs.

## Version 0.2.2 (8/29/23)
* Add libraries to support reading cgroup information so we can constrain memory on docker containers.
* Update to python 3.11.4.

## Version 0.2.1 (8/16/23)
* Switch to using condaforge/mambaforge as the base, which avoids having to download a conda environment and/or install mamba.  The container is much smaller now too.

## Version 0.1.9 (6/12/23)
* Updated to Ubuntu 23.10

## Version 0.1.8 (5/11/23)
* Moved to Python 3.11.
* Do not install numba.

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
