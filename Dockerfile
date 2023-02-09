# Use Ubuntu 23.04
FROM ubuntu:23.04

# set the shell to bash
SHELL [ "/bin/bash", "--login", "-c" ]

# Prepare environment
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
                    pkg-config \
                    xterm \
                    libgl1-mesa-glx \
                    libx11-xcb1 \
                    libxkbcommon-x11-dev \
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

# Install and set up the appropriate miniconda for the architecture
ARG CONDA_VERSION=py39_4.12.0

RUN curl -fso install-conda.sh \
    https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-$(uname -s)-$(uname -m).sh
RUN bash install-conda.sh -b -p /usr/local/miniconda
RUN rm install-conda.sh


# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="/usr/local/miniconda/bin:$PATH" \
    CPATH="/usr/local/miniconda/include/:$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1


# add the conda-forge channel
RUN conda config --add channels conda-forge

# Install mamba so we can install packages before the heat death of the universe
RUN conda install -y "mamba>=1.0"
RUN mamba update -n base conda

# install conda-build
RUN mamba install -y conda-build

# install minimal python
RUN mamba install -y python pip

# install a standard set of scientific software
RUN mamba install -y numpy scipy matplotlib pandas 
RUN mamba install -y scikit-image scikit-learn nilearn
RUN mamba install -y statsmodels nibabel
RUN mamba install -y numba pyfftw 
RUN mamba install -y versioneer tqdm

# install pyqt stuff
RUN mamba install pyqt pyqt5-sip pyqtgraph

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN mamba install -y requests --force-reinstall

# reinstall xinerama0 to get pyqt working
RUN apt-get install -y --reinstall libxcb-xinerama0

# clean up
RUN conda clean --all

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
