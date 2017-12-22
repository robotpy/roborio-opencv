#!/bin/bash -e

OPENCV_VERSION=3.3.1

cd `dirname $0`

function download {
  URI="$1"
  FNAME=$(basename $1)

  if [ ! -f "$FNAME" ]; then
    wget $URI
  fi
}

if ! which apt-add-repository; then
  apt update
  apt install -y software-properties-common
fi

if ! which frcmake; then
  apt-add-repository ppa:wpilib/toolchain-beta
  apt update
  apt install -y frc-toolchain frcmake
fi

# Note: Java build seems to be broken (needs JNI?), since FIRST provides java
#       builds I'm not going to spend the time to fix it
#if ! which javac || ! javac -version 2>&1  | grep 1\\.8; then
#  add-apt-repository ppa:webupd8team/java
#  apt update
#  apt install -y oracle-java8-installer oracle-java8-set-default
#fi

#if ! which ant; then
#  apt install -y ant
#fi

if ! which unzip; then
  apt install -y unzip
fi

if ! which python; then
  apt install -y python
fi

DEPS=`cat deps`

[ -d downloads ] || mkdir downloads
pushd downloads

for dep in $DEPS; do
  download "$dep"
done

popd

download https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz

if [ ! -d opencv-${OPENCV_VERSION} ]; then
  tar -xf ${OPENCV_VERSION}.tar.gz
fi

#download https://github.com/Itseez/opencv/commit/e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff
#pushd opencv-${OPENCV_VERSION}
#patch -p1 --forward < ../e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff
#popd

echo "Done. Ready to build OpenCV!"
