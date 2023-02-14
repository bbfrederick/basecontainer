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

# Install and set up the appropriate miniconda for the architecture
ARG CONDA_VERSION=py310_23.1.0-1
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
RUN mamba install -y numba
RUN mamba install -y versioneer tqdm

# install pyfftw.  Use pip to get around bad conda build
#mamba install -y "pyfftw=0.13.0=py39h51d1ae8_0"; \
#ARG TARGETPLATFORM
#RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
#        echo "ARCHITECTURE=amd64"; \
#        pip install pyfftw;
#    else \
#        if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
#            echo "ARCHITECTURE=aarch64"; \
#            #mamba install -y "pyfftw>=0.13.1" ; \
#            pip install pyfftw;
#        else \
#            echo "ARCHITECTURE=amd64"; \
#            #mamba install -y "pyfftw=0.13.0=py39h51d1ae8_0"; \
#            pip install pyfftw;
#        fi
#    fi
RUN pip install pyfftw

# install pyqt stuff
RUN mamba install pyqt pyqt5-sip "pyqtgraph<0.13.0"

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN mamba install -y requests --force-reinstall

# reinstall several things to get pyqt working
RUN apt-get install -y --reinstall libqt5dbus5 
RUN apt-get install -y --reinstall libqt5widgets5 
RUN apt-get install -y --reinstall libqt5network5 
RUN apt-get remove qtchooser
RUN apt-get install -y --reinstall libqt5gui5 
RUN apt-get install -y --reinstall libqt5core5a 
RUN apt-get install -y --reinstall libxkbcommon-x11-0
RUN apt-get install -y --reinstall libxcb-xinerama0

# proposed fix to the 'Could not load the Qt platform plugin "xcb" in ""' problem
#ENV QT_QPA_PLATFORM=offscreen

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
