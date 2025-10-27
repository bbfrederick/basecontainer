# Use bookworm as a base
FROM python:3.14-bookworm

# get build arguments
ARG BUILD_TIME
ARG BRANCH
ARG GITVERSION
ARG GITSHA
ARG GITDATE

# set and echo environment variables
ENV BASECONTAINER_BUILD_TIME=$BUILD_TIME
ENV BASECONTAINER_BRANCH=$BRANCH
ENV BASECONTAINER_GITVERSION=${GITVERSION}
ENV BASECONTAINER_GITSHA=${GITSHA}
ENV BASECONTAINER_GITDATE=${GITDATE}

RUN echo "BRANCH: "$BASECONTAINER_BRANCH
RUN echo "BUILD_TIME: "$BASECONTAINER_BUILD_TIME
RUN echo "GITVERSION: "$BASECONTAINER_GITVERSION
RUN echo "GITSHA: "$BASECONTAINER_GITSHA
RUN echo "GITDATE: "$BASECONTAINER_GITDATE

# set the shell to bash
SHELL [ "/bin/bash", "--login", "-c" ]

# Prepare the unix environment
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get update --fix-missing && \
    apt update && \
    apt-get install -y --no-install-recommends tzdata && \
    apt-get install -y --no-install-recommends cgroup-tools
RUN apt-get install -y --no-install-recommends \
                    curl \
                    wget \
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
                    lsb-release \
                    jq \
                    git
RUN apt-get install -y --no-install-recommends \
                    libdbus-1-dev \
                    libdbus-glib-1-dev \
                    libegl1-mesa-dev \
                    libgl1-mesa-glx \
                    libglu1-mesa-dev \
                    libx11-xcb1 \
                    libx11-xcb-dev \
                    libxi-dev \
                    '^libxcb.*-dev' \
                    libxcb-xinerama0 \
                    libxkbcommon-dev \
                    libxkbcommon-x11-dev \
                    libxrender-dev
RUN apt-get install -y --no-install-recommends \
                    libgtk2.0-0 \
                    libgomp1
RUN apt-get install -y --no-install-recommends \
                    dc \
                    procps \
                    file

# install vim and mg so we can debug the container
RUN apt install -y vim mg

# Pull in the newest versions of packages to address any security issues
RUN apt-get dist-upgrade -y 

# Clean up
RUN apt-get autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## install mamba to have it around
RUN cd /root; curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN cd /root; /bin/bash Miniforge3-$(uname)-$(uname -m).sh -b -p /opt/miniforge3
RUN cd /root; rm -f Miniforge3-$(uname)-$(uname -m).sh
RUN /opt/miniforge3/bin/mamba shell init --shell bash 

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="$PATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# make a scientific software environment
RUN /opt/miniforge3/bin/mamba create -n science python==$(python --version | awk '{print $2}') pip mamba
RUN echo "export PATH='/opt/miniforge3/envs/science/bin:$PATH'" >> ~/.login
RUN echo "mamba activate science" >> ~/.login
RUN echo "export PATH='/opt/miniforge3/envs/science/bin:$PATH'" >> ~/.bashrc
RUN echo "mamba activate science" >> ~/.bashrc
ENV PYTHONENVBIN=/opt/miniforge3/envs/science/bin

# install uv to make installations faster
RUN pip install uv

# now install a standard set of scientific software
RUN uv pip install s3fs awscli "cryptography>=42.0.4" "urllib3>=1.26.17"

RUN uv pip install \
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
        versioneer \
        h5py \
        torch \
        torchvision \
        tensorflow \
        "tf-keras>=2.18.0" \
        tensorboard

# install pyqt stuff
RUN uv pip install PyQt6 pyqtgraph

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install --upgrade --force-reinstall requests "certifi>=2024.8.30"

# NDA downloader
RUN uv pip install nda-tools keyrings.alt

# clean up
RUN pip cache purge
RUN mamba clean --all

ENV RUNNING_IN_CONTAINER=1

RUN cd /root; TZ=GMT date "+%Y-%m-%d %H:%M:%S" > buildtime-basecontainer

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="basecontainer" \
      org.label-schema.description="scientific python/mamba/uv base container for fredericklab containers" \
      org.label-schema.url="http://nirs-fmri.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/bbfrederick/basecontainer" \
      org.label-schema.version=$VERSION
