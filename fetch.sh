#!/bin/bash -e

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
  apt-add-repository ppa:wpilib/toolchain 
  apt update
  apt install -y frc-toolchain frcmake
fi

if ! which javac || ! javac -version 2>&1  | grep 1\\.8; then
  add-apt-repository ppa:webupd8team/java
  apt update
  apt install -y oracle-java8-installer oracle-java8-set-default
fi

if ! which ant; then
  apt install -y ant
fi

DEPS=`cat deps`

[ -d ipkg ] || mkdir ipkg
pushd ipkg

for dep in $DEPS; do
  download "$dep"
done

popd

download https://github.com/Itseez/opencv/archive/3.1.0.tar.gz

if [ ! -d opencv-3.1.0 ]; then
  tar -xf 3.1.0.tar.gz
fi

download https://github.com/Itseez/opencv/commit/e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff

pushd opencv-3.1.0
patch -p1 --forward < ../e489f29d0fd8f40683ff7294f4f2060f6bbe0a5e.diff
popd

echo "Done. Ready to build OpenCV!"
