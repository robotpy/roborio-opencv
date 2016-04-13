#!/bin/bash -e

pushd `dirname $0`
ROOT=`pwd`
popd

BUILD=`pwd`/build
SYSROOT="$BUILD"/sysroot
CVDIR="$ROOT"/opencv-3.1.0

function unpack_ipk {
  FNAME=$(basename $1)
  
  ar -x "$ROOT"/ipkg/"$FNAME"
  tar -xf data.tar.gz -C "$SYSROOT"
  rm data.tar.gz control.tar.gz debian-binary 
}

function assert_path {
  if [ ! $1 "$2" ]; then
    echo "$2 does not exist, exiting"
    exit 1
  fi
}

if [ -z "$JAVA_HOME" ]; then
  echo "ERROR: JAVA_HOME not set! (maybe you need to do '. /etc/profile', or logout/login)"
  exit 1
fi

sed -i 's/arm-linux-gnueabi/arm-frc-linux-gnueabi/g' "$CVDIR"/platforms/linux/arm-gnueabi.toolchain.cmake

[ -d build ] || mkdir build
pushd build

[ ! -d sysroot ] || rm -rf sysroot
mkdir sysroot

for dep in `cat "$ROOT"/deps`; do
  unpack_ipk "$dep"
done

PYTHON2_INCLUDE_PATH="$SYSROOT"/usr/local/include/python2.7
PYTHON2_LIBRARY="$SYSROOT"/usr/local/lib/libpython2.7.so
PYTHON2_NUMPY_INCLUDE_DIRS="$SYSROOT"/usr/local/lib/python2.7/site-packages/numpy/core/include

PYTHON3_INCLUDE_PATH="$SYSROOT"/usr/local/include/python3.5m
PYTHON3_LIBRARY="$SYSROOT"/usr/local/lib/libpython3.5m.so.1.0
PYTHON3_NUMPY_INCLUDE_DIRS="$SYSROOT"/usr/local/lib/python3.5/site-packages/numpy/core/include

assert_path -d "$PYTHON2_INCLUDE_PATH"
assert_path -f "$PYTHON2_LIBRARY"
assert_path -d "$PYTHON2_NUMPY_INCLUDE_DIRS"

assert_path -d "$PYTHON3_INCLUDE_PATH"
assert_path -f "$PYTHON3_LIBRARY"
assert_path -d "$PYTHON3_NUMPY_INCLUDE_DIRS"

CMAKE_PREFIX_PATH="$SYSROOT"/usr/local frcmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_NEON=ON -DENABLE_VFPV3=ON \
  -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
  -DWITH_OPENCL=NO \
  "-DPYTHON2_INCLUDE_PATH=${PYTHON2_INCLUDE_PATH}" \
  "-DPYTHON2_LIBRARY=${PYTHON2_LIBRARY}" \
  "-DPYTHON2_NUMPY_INCLUDE_DIRS=${PYTHON2_NUMPY_INCLUDE_DIRS}" \
  "-DPYTHON3_INCLUDE_PATH=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_INCLUDE_DIR=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_INCLUDE_DIR2=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_LIBRARY=${PYTHON3_LIBRARY}" \
  "-DPYTHON3_NUMPY_INCLUDE_DIRS=${PYTHON3_NUMPY_INCLUDE_DIRS}" \
  "$CVDIR"

if which nproc; then
  MAKEARGS="-j `nproc`"
fi

make $MAKEARGS

cpack -G TGZ
mv OpenCV-unknown-.tar.gz /vagrant/OpenCV-3.1.0-cortexa9-vfpv3.tar.gz

popd
