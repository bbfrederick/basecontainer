#!/bin/bash

set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=fredericklab
# image name
IMAGE=basecontainer

# ensure we're up to date
git pull

# bump version
python revversion.py
version=`cat VERSION | sed 's/+/ /g' | sed 's/v//g' | awk '{print $1}'`
echo "version: $version"

# run build
docker buildx build . \
    --platform linux/arm64,linux/amd64 \
    --provenance=true \
    --sbom=true \
    --tag $USERNAME/$IMAGE:latest \
    --build-arg VERSION=$version \
    --build-arg BUILD_DATE=`date +"%Y%m%dT%H%M%S"` \
    --build-arg VCS_REF=`git rev-parse HEAD` --push
