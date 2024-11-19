#!/bin/bash

VERSION=latest

docker pull fredericklab/basecontainer:${VERSION}
docker run -it fredericklab/basecontainer:${VERSION} bash
