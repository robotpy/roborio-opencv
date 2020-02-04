#!/bin/bash -ex

OPENCV_VERSION=4.2.0
PYTHON_VERSION=3.8
COMPILER=arm-frc2019-linux-gnueabi

pushd `dirname $0`
ROOT=`pwd`
popd

BUILD=`pwd`/build
SYSROOT="$BUILD"/sysroot
CMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake
CVDIR="$ROOT"/opencv-${OPENCV_VERSION}

function unpack_download {
  FNAME=$(basename $1)
  EXT="${FNAME##*.}"

  case "$EXT" in
    "ipk")
      ar -x "$ROOT"/downloads/"$FNAME"
      tar -xf data.tar.gz -C "$SYSROOT"
      rm data.tar.gz control.tar.gz debian-binary
      ;;
    *)
      echo "$FNAME has unknown file type '$EXT' to unpack"
      exit 1
      ;;
  esac
}

function assert_path {
  if [ ! $1 "$2" ]; then
    echo "$2 does not exist, exiting"
    exit 1
  fi
}

# if [ -z "$JAVA_HOME" ]; then
#   echo "ERROR: JAVA_HOME not set! (maybe you need to do '. /etc/profile', or logout/login)"
#   exit 1
# fi

sed -i "s/arm-linux-gnueabi/$COMPILER/g" "$CVDIR"/platforms/linux/arm-gnueabi.toolchain.cmake

[ -d build ] || mkdir build
pushd build

[ ! -d sysroot ] || rm -rf sysroot
mkdir sysroot

PYTHON3_SITE_PACKAGES="$SYSROOT"/usr/local/lib/python${PYTHON_VERSION}/site-packages/
PYTHON3_INCLUDE_PATH="$SYSROOT"/usr/local/include/python${PYTHON_VERSION}
PYTHON3_LIBRARY="$SYSROOT"/usr/local/lib/libpython${PYTHON_VERSION}.so.1.0
PYTHON3_NUMPY_INCLUDE_DIRS="$PYTHON3_SITE_PACKAGES"/numpy/core/include

mkdir -p "$PYTHON3_SITE_PACKAGES"
echo "$PYTHON3_SITE_PACKAGES"

for dep in `cat "$ROOT"/deps`; do
  unpack_download "$dep"
done

assert_path -d "$PYTHON3_INCLUDE_PATH"
assert_path -f "$PYTHON3_LIBRARY"
assert_path -d "$PYTHON3_NUMPY_INCLUDE_DIRS"

CMAKE_PREFIX_PATH="$SYSROOT"/usr/local cmake \
  -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE}" \
  -DOPENCV_VCSVERSION=${OPENCV_VERSION} \
  -DCMAKE_BUILD_TYPE=Release \
  -DOPENCV_GENERATE_PKGCONFIG=ON \
  -DENABLE_NEON=ON -DENABLE_VFPV3=ON \
  -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
  -DWITH_OPENCL=NO \
  -DOPENCV_SKIP_PYTHON_LOADER=ON \
  -DOPENCV_PYTHON3_INSTALL_PATH=lib/python${PYTHON_VERSION}/site-packages \
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
mv OpenCV-${OPENCV_VERSION}-arm.tar.gz ${ROOT}/OpenCV-${OPENCV_VERSION}-cortexa9-vfpv3.tar.gz
popd
