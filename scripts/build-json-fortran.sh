#!/bin/sh

# Fetch and build json-fortran, a Simsphere dependency

cd /tmp
git clone git://github.com/jacobwilliams/json-fortran
cmake -H./json-fortran -B./json-build
cmake --build ./json-build
cmake --target install ./json-build
