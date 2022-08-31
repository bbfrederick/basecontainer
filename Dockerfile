# Use Ubuntu 20.04 LTS
FROM ubuntu:20.04

# Prepare environment
RUN df -h
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
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
                    lsb-release \
                    git
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get install -y tzdata
RUN apt-get install -y --reinstall libqt5dbus5 
RUN apt-get install -y --reinstall libqt5widgets5 
RUN apt-get install -y --reinstall libqt5network5 
RUN apt-get remove qtchooser
RUN apt-get install -y --reinstall libqt5gui5 
RUN apt-get install -y --reinstall libqt5core5a 
RUN apt-get install -y --reinstall libxkbcommon-x11-0
RUN apt-get install -y --reinstall libxcb-xinerama0


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Installing and setting up miniconda
RUN curl -sSLO https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh && \
    bash Miniconda3-py39_4.12.0-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm Miniconda3-py39_4.12.0-Linux-x86_64.sh


# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="/usr/local/miniconda/bin:$PATH" \
    CPATH="/usr/local/miniconda/include/:$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1


# add the conda-forge channel
RUN conda config --add channels conda-forge

# Install mamba so we can install packages before the heat death of the universe
RUN conda install -c conda-forge -y mamba
RUN conda clean --all

# install conda-build
RUN conda install -y conda-build


# Installing precomputed python packages
#RUN mamba install -y python \
#                     pip \
#                     scipy \
#                     numpy \
#                     matplotlib \
##                     mkl \
#                     mkl-service \
#                     statsmodels \
#                     scikit-image \
#                     scikit-learn \
#                     nibabel \
#                     nilearn \
#                     keras \
#                     h5py \
#                     "tensorflow>=2.4.0" \
#                     pyqtgraph \
#                     pyfftw \
#                     pandas \
#                     versioneer \
#                     numba; sync && \
#    chmod -R a+rX /usr/local/miniconda; sync && \
#    chmod +x /usr/local/miniconda/bin/*; sync && \
#    conda-build purge-all; sync && \
#    conda clean -tipsy && sync
#RUN df -h

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