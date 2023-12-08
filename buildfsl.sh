#!/bin/bash

while read dep; do
   project=${dep%%=*}
   version=${dep#*=}
   git clone "https://git.fmrib.ox.ac.uk/fsl/${project}"
   cd ${project}
   git checkout ${version}
   make
   make install
   cd ..
done < fsldeps.txt
