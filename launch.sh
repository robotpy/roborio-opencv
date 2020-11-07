#!/bin/bash

docker run \
    --rm -it -v $(pwd):/build/opencv:Z \
    --hostname roborio-opencv \
    -w /build/opencv \
    robotpy/roborio-cross-ubuntu:2021.1 /bin/bash