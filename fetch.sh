#!/bin/bash -e

OPENCV_VERSION=4.5.0

cd `dirname $0`

function download {
  URI="$1"
  FNAME=$(basename $1)

  if [ ! -f "$FNAME" ]; then
    wget $URI
  fi
}

if ! which cmake; then
  apt-get update
  apt-get install -y cmake --no-install-recommends
fi

download https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz

if [ ! -d opencv-${OPENCV_VERSION} ]; then
  tar -xf ${OPENCV_VERSION}.tar.gz
fi

#download https://github.com/Itseez/opencv/commit/e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff
#pushd opencv-${OPENCV_VERSION}
#patch -p1 --forward < ../e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff
#popd

echo "Done. Ready to build OpenCV!"
