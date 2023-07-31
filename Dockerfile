# Use Ubuntu 23.10
FROM ubuntu:23.10

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

# Install and set up the appropriate miniconda for the architecture
#ARG CONDA_VERSION=py311_23.5.2-0
#RUN curl -fso install-conda.sh \
    #https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-$(uname -s)-$(uname -m).sh
#RUN bash install-conda.sh -b -p /usr/local/miniconda
#RUN rm install-conda.sh

# Install and set up the appropriate micromamba for the architecture
ARG MABMA_VERSION=23.1.0-4
ARG SYSTYPE=$(uname -s)
ARG PROCTYPE=$(uname -m)
RUN curl -fso install-mamba.sh \
    https://github.com/conda-forge/miniforge/releases/${MAMBA_VERSION}/download/Mambaforge-${SYSTYPE}-${PROCTYPE}.sh
RUN bash install-mamba.sh -b -p /usr/local/minimamba
RUN rm install-mamba.sh

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="/usr/local/minimamba/bin:$PATH" \
    CPATH="/usr/local/minimamba/include/:$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

RUN ls /usr/local/minimamba

# update mamba
RUN mamba install mamba

# install conda-build
#RUN conda install -y conda-build

# add the conda-forge channel
#RUN conda config --add channels conda-forge

# Install mamba so we can install packages before the heat death of the universe
#RUN conda install -y "mamba>=1.0" "certifi>=2022.12.07"

# install a standard set of scientific software
RUN mamba install -y numpy scipy matplotlib pandas 
RUN mamba install -y scikit-image scikit-learn nilearn
RUN mamba install -y statsmodels nibabel
#RUN mamba install -y numba
RUN mamba install -y versioneer tqdm

# install pyfftw.  Use pip to get around bad conda build
#mamba install -y pyfftw \
RUN pip install pyfftw

# install pyqt stuff
RUN mamba install pyqt pyqt5-sip "pyqtgraph<0.13.0"

# security patches
RUN mamba install -y "wheel>=0.38.1" "certifi>=2022.12.07"

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN mamba install -y requests --force-reinstall

# clean up
RUN mamba clean -y --all

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
