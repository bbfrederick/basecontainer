# Use condaforge/mambaforge to save time getting a fast python environment
FROM fredericklab/basecontainer:latest

RUN mamba create \
    -c https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/public/ \
    -c conda-forge \
    -p ./fsl \
    make \
    cxx-compiler \
    zlib \
    boost-cpp \
    openblas \
    nlohmann_json     \
    fsl-base \
    fsl-data_standard \
    fsl-misc_tcl \
    fsl-misc_scripts

#source <base-conda-environment>/bin/activate ./fsl
#ENV FSLDIR=${CONDA_PREFIX}
#ENV FSLDEVDIR=${CONDA_PREFIX}
#RUN source $FSLDIR/etc/fslconf/fsl-devel.sh

# Copy the install script
COPY . /src/basecontainer-plus

#RUN buildfsl.sh

ENV IS_DOCKER_8395080871=1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="basecontainer-plus" \
      org.label-schema.description="updated mambaforge container for fredericklab containers" \
      org.label-schema.url="http://nirs-fmri.net" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/bbfrederick/basecontainer-plus" \
      org.label-schema.version=$VERSION
