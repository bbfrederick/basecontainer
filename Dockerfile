# Use condaforge/mambaforge to save time getting a fast python environment
FROM condaforge/mambaforge 

# set the shell to bash
SHELL [ "/bin/bash", "--login", "-c" ]

# Prepare the unix environment
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get update && \
    apt update && \
    apt-get install -y tzdata && \
    apt-get install -y cgroup-tools && \
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
                    jq \
                    s3fs \
                    awscli \
                    git
                     

RUN apt install -y vim
RUN apt-get clean

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="$PATH" \
    CPATH="$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# install a standard set of scientific software
RUN mamba install -y "python==3.12.4"
RUN mamba install -y numpy scipy matplotlib pandas pyarrow
RUN mamba install -y scikit-image scikit-learn nilearn
RUN mamba install -y statsmodels nibabel
RUN mamba install -y tqdm
RUN mamba install -y tomlkit
RUN mamba install -y memory_profiler
RUN mamba install -y cgroupspy
RUN mamba install -y versioneer

# install pyqt stuff
RUN mamba install pyqt pyqt5-sip pyqtgraph

# Installing additional precomputed python packages
# tensorflow seems to really want to install with pip
RUN mamba install h5py 
RUN mamba install keras 
RUN pip install tensorflow

# security patches
RUN mamba install -y "wheel>=0.41.1"
#RUN mamba install -y "certifi>=2024.7.4"

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN mamba install -y requests --force-reinstall

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install --upgrade --force-reinstall requests "certifi>=2024.7.4"

# NDA downloader
RUN pip install nda-tools keyrings.alt

# clean up
#RUN mamba clean --packages
RUN pip cache purge

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /root; TZ=GMT date "+%Y-%m-%d %H:%M:%S" > buildtime-basecontainer

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="basecontainer" \
      org.label-schema.description="updated mambaforge container for fredericklab containers" \
      org.label-schema.url="http://nirs-fmri.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/bbfrederick/basecontainer" \
      org.label-schema.version=$VERSION
