# Use Ubuntu 22.04
FROM ubuntu:22.04

# Prepare environment
RUN df -h
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get update && \
    apt-get install -y tzdata && \
    apt-get install -y --no-install-recommends \
                    curl \
                    bzip2 \
                    ca-certificates \
                    xvfb \
                    build-essential \
                    autoconf \
                    libtool \
                    gnupg \
                    python3.9 \
                    pip \
                    pkg-config \
                    xterm \
                    libgl1-mesa-glx \
                    libx11-xcb1 \
                    lsb-release \
                    s3fs \
                    awscli \
                    jq \
                    git
RUN apt-get install -y --reinstall libqt5dbus5 
RUN apt-get install -y --reinstall libqt5widgets5 
RUN apt-get install -y --reinstall libqt5network5 
RUN apt-get remove qtchooser
RUN apt-get install -y --reinstall libqt5gui5 
RUN apt-get install -y --reinstall libqt5core5a 
RUN apt-get install -y --reinstall libxkbcommon-x11-0
RUN apt-get install -y --reinstall libxcb-xinerama0

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="/usr/local/bin:$PATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1


# install minimal python
RUN pip install --upgrade pip
RUN pip install requests

# install a minimal set of scientific software
RUN pip install numpy scipy matplotlib pandas

ENV IS_DOCKER_8395080871=1
RUN apt-get install -y --reinstall libxcb-xinerama0

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="basecontainer" \
      org.label-schema.description="updated ubuntu python base container for fredericklab containers" \
      org.label-schema.url="http://nirs-fmri.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/bbfrederick/basecontainer" \
      org.label-schema.version=$VERSION
