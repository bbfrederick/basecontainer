#!/bin/env python
from codecs import open
from os import path

# Always prefer setuptools over distutils
from setuptools import find_packages, setup

import versioneer

here = path.abspath(path.dirname(__file__))

# Write version number out to VERSION file
version = versioneer.get_version()
try:
    with open(path.join(here, "VERSION"), "w", encoding="utf-8") as f:
        f.write(version)
except PermissionError:
    print("can't write to VERSION file - moving on")
