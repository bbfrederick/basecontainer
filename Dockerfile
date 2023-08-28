# Use condaforg/mambaforge to save time getting a fast python environment
FROM condaforge/mambaforge

# set the shell to bash
SHELL [ "/bin/bash", "--login", "-c" ]

# Prepare the unix environment
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
                    jq \
                    cgroup-bin \
                    git
RUN apt-get clean

# Set CPATH for packages relying on compiled libs (e.g. indexed_gzip)
ENV PATH="$PATH" \
    CPATH="$CPATH" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONNOUSERSITE=1

# install a standard set of scientific software
RUN mamba install -y "python==3.11"
RUN mamba install -y numpy scipy matplotlib pandas 
RUN mamba install -y scikit-image scikit-learn nilearn
RUN mamba install -y statsmodels nibabel
RUN mamba install -y versioneer tqdm
RUN mamba install -y s3fs awscli 

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
RUN pip cache purge

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
