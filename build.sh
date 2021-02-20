#!/bin/bash -ex

OPENCV_VERSION=4.5.1
PYTHON_VERSION=3.9
NUMPY_VERSION=1.19.5
OPENBLAS_VERSION=0.3.10
COMPILER=arm-frc2020-linux-gnueabi

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

PYTHON3_INCLUDE_PATH=/build/crosspy/include/python${PYTHON_VERSION}
PYTHON3_SITE_PACKAGES=/build/venv/cross/lib/python${PYTHON_VERSION}/site-packages/
PYTHON3_NUMPY_INCLUDE_DIRS="$PYTHON3_SITE_PACKAGES"/numpy/core/include

OPENBLAS_INCLUDE_DIR=/build/venv/cross/include
OPENBLAS_LIB=/build/venv/cross/lib

/build/venv/bin/cross-python -m pip --disable-pip-version-check install \
  numpy==${NUMPY_VERSION}

assert_path -d "$PYTHON3_INCLUDE_PATH"
#assert_path -f "$PYTHON3_LIBRARY"
assert_path -d "$PYTHON3_NUMPY_INCLUDE_DIRS"

CMAKE_PREFIX_PATH=/build/venv/cross cmake \
  -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE}" \
  -DOPENCV_VCSVERSION=${OPENCV_VERSION} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DWITH_CUDA=OFF \
  -DWITH_IPP=OFF \
  -DWITH_ITT=OFF \
  -DWITH_OPENCL=NO \
  -DWITH_FFMPEG=OFF \
  -DWITH_OPENEXR=OFF \
  -DWITH_GSTREAMER=OFF \
  -DWITH_GTK=OFF \
  -DWITH_1394=OFF \
  -DWITH_JASPER=OFF \
  -DWITH_TIFF=OFF \
  -DWITH_WEBP=OFF \
  -DWITH_PROTOBUF=OFF \
  \
  -DBUILD_JPEG=ON -DBUILD_PNG=ON -DBUILD_ZLIB=ON \
  \
  -DOPENCV_GENERATE_PKGCONFIG=ON \
  -DENABLE_NEON=ON -DENABLE_VFPV3=ON \
  \
  -DBUILD_opencv_apps=OFF \
  -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
  \
  -DOPENCV_SKIP_PYTHON_LOADER=ON \
  -DOPENCV_PYTHON3_INSTALL_PATH=lib/python${PYTHON_VERSION}/site-packages \
  -DBUILD_opencv_python2=OFF \
  -DBUILD_opencv_python3=ON \
  "-DPYTHON3_INCLUDE_PATH=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_INCLUDE_DIR=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_INCLUDE_DIR2=${PYTHON3_INCLUDE_PATH}" \
  "-DPYTHON3_NUMPY_INCLUDE_DIRS=${PYTHON3_NUMPY_INCLUDE_DIRS}" \
  "$CVDIR"

if which nproc; then
  MAKEARGS="-j `nproc`"
fi

make $MAKEARGS

cpack -G TGZ
mv OpenCV-${OPENCV_VERSION}-arm.tar.gz ${ROOT}/OpenCV-${OPENCV_VERSION}-cortexa9-vfpv3.tar.gz
popd
