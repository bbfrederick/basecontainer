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
                    lsb-release \
                    jq \
                    s3fs \
                    awscli \
                    git
RUN apt-get install -y \
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
RUN apt-get upgrade -y python3
RUN apt-get autoremove

RUN apt install -y vim
RUN apt-get clean

## install mamba to have it around
RUN cd /root; curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN cd /root; /bin/bash Miniforge3-$(uname)-$(uname -m).sh -b -p /opt/miniforge3
RUN cd /root; rm -f Miniforge3-$(uname)-$(uname -m).sh
RUN /opt/miniforge3/bin/mamba init

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="$PATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# make a scientific software environment
RUN /opt/miniforge3/bin/mamba create -n science python==$(python --version | awk '{print $2}') pip mamba
RUN echo "mamba activate science" >> ~/.bashrc
#RUN echo "export PATH='/opt/miniforge3/envs/science/bin:$PATH'" >> ~/.bashrc
RUN mamba activate science

# now install a standard set of scientific software
RUN pip install uv
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
        versioneer

# install pyqt stuff
RUN uv pip install PyQt6 pyqtgraph

# Installing additional precomputed python packages
RUN uv pip install h5py keras tensorflow

# security patches
RUN uv pip install "wheel>=0.44.0" "werkzeug>=3.0.6"

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install requests --force-reinstall

# hack to get around the super annoying "urllib3 doesn't match" warning
RUN pip install --upgrade --force-reinstall requests "certifi>=2024.8.30"

# NDA downloader
RUN uv pip install nda-tools keyrings.alt

# clean up
RUN pip cache purge

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /root; TZ=GMT date "+%Y-%m-%d %H:%M:%S" > buildtime-basecontainer

# make a non-root user and switch to them
ENV USER=default
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --groups users \
    --home /home/$USER \
    $USER
USER $USER
RUN /opt/miniforge3/bin/mamba init
RUN echo "mamba activate science" >> ~/.bashrc

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
