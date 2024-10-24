# Use slim-bullseye as a base
FROM python:3.12-slim-bullseye

# set the shell to bash
SHELL [ "/bin/bash", "--login", "-c" ]

# Prepare the unix environment
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get update --fix-missing && \
    apt update && \
    apt-get install -y tzdata && \
    apt-get install -y cgroup-tools
RUN apt-get install -y --no-install-recommends \
                    curl \
                    bzip2 \
                    ca-certificates \
                    xvfb \
                    build-essential \
                    autoconf \
                    libtool \
                    gnupg \
                    pkg-config 
RUN apt-get install -y --no-install-recommends \
                    xterm \
                    libgl1-mesa-glx \
                    libx11-xcb1 \
                    libxkbcommon-x11-dev \
                    lsb-release \
                    jq \
                    s3fs \
                    awscli \
                    git
RUN apt-get install -y --no-install-recommends \
                    qtcreator qtbase5-dev qt5-qmake cmake
                     
RUN apt install -y vim
RUN apt-get clean

## install mamba to have it around
RUN cd /root; curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN cd /root; /bin/bash Miniforge3-$(uname)-$(uname -m).sh -b -p /miniforge3
RUN cd /root; rm -f Miniforge3-$(uname)-$(uname -m).sh
RUN /miniforge3/bin/mamba init

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="$PATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# install a standard set of scientific software
RUN pip install uv
RUN uv pip install --system \
        numpy \
        scipy \
        matplotlib \
        pandas \
        pyarrow \
        scikit-image \
        scikit-learn \
        nilearn \
        statsmodels \
        nibabel \
        tqdm \
        memory_profiler \
        cgroupspy \
        versioneer

# install pyqt stuff
RUN uv pip install --system pyqt5-sip pyqtgraph
#RUN uv pip install --system pyqt5

# Installing additional precomputed python packages
RUN uv pip install --system h5py keras tensorflow

# security patches
RUN uv pip install --system "wheel>=0.44.0"

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install requests --force-reinstall

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install --upgrade --force-reinstall requests "certifi>=2024.8.30"

# NDA downloader
RUN uv pip install --system nda-tools keyrings.alt


# clean up
RUN pip cache purge

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /root; TZ=GMT date "+%Y-%m-%d %H:%M:%S" > buildtime-basecontainer

RUN useradd -ms /bin/bash default
#USER default

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
