
PYVERSION = 3.12
VERSION = 4.8.0

DOWNLOAD_FROM = https://github.com/opencv/opencv/archive/${VERSION}.tar.gz
LIBGZIP = $(abspath $(notdir ${DOWNLOAD_FROM}))
SRCDIR = opencv-$(VERSION)
BUILT_TGZ = OpenCV-$(VERSION)-arm.tar.gz

.PHONY: all
all: package

${LIBGZIP}:
	wget ${DOWNLOAD_FROM}

${SRCDIR}: ${LIBGZIP}
	tar -xf ${LIBGZIP}

${BUILT_TGZ}: ${SRCDIR}
	./build.sh

.PHONY: package
package: ${BUILT_TGZ}
	rm -rf coredata devdata data

	# create release package
	mkdir -p coredata/usr/local/lib
	xtar -xf ${BUILT_TGZ} -C coredata/usr/local --strip=1 \
		'*/lib/lib*so.408' \
		'*/share/opencv4/haarcascades/*.xml' \
		'*/share/opencv4/lbpcascades/*.xml'
	roborio-gen-whl data-core.py coredata -o dist --strip arm-frc2024-linux-gnueabi-strip

	# create dev package
	mkdir -p devdata/usr/local/lib
	xtar -xf ${BUILT_TGZ} -C devdata/usr/local --strip=1 \
		'*/include/*' \
		'*/lib/lib*so' \
		'*/lib/cmake/opencv4/*.cmake' \
		'*/lib/pkgconfig/*'
	roborio-gen-whl --dev data-core.py devdata -o dist

	# create python package
	mkdir -p data/usr/local/lib/python$(PYVERSION)/site-packages
	xtar -xf ${BUILT_TGZ} -C data/usr/local/lib/python$(PYVERSION)/site-packages --strip=4 \
		'*/lib/python$(PYVERSION)/site-packages/cv2*.so'
	roborio-gen-whl data-py.py data -o dist --strip arm-frc2024-linux-gnueabi-strip
