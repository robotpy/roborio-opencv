OpenCV 4.5.0 build for RoboRIO
==============================

This is a set of scripts that will build OpenCV for the RoboRIO with bindings for:

* C++
* Python 3.9

The result of the compilation process is a zipfile that can be turned into IPK
files using the [roborio-packages](https://github.com/robotpy/roborio-packages)
repository.

**NOTE**: For 2017+, OpenCV 3.x is well-supported for C++ and Java by WPILib,
so if you're looking to use those languages you should use their stuff instead.

RoboRIO Installation
====================

You can use the [RobotPy Installer](https://github.com/robotpy/robotpy-installer)
to install these packages. First, download the package:

    python3 -m robotpy-installer download-opkg python38-opencv4

Then, connect to the network with the RoboRIO, and install it:

    python3 installer.py install-opkg python38-opencv4

via opkg
--------

Another way to install these packages is to set up the RobotPy opkg feed
on your RoboRIO.

First, setup the opkg feed as directed at https://github.com/robotpy/roborio-packages

Once the feed is added, issue an `opkg update` and then you can install
packages using the following commands (requires internet access).

    opkg install python38-opencv4

Manual Installation
-------------------

TODO: document this

Usage
=====

For detailed information about OpenCV, see their [website](http://opencv.org/).
There's lots of documentation and tutorials/etc available.

Using the Python bindings
-------------------------

See the image processing section of the Programmer's Guide at the [RobotPy documentation site](http://robotpy.readthedocs.io)
for details.

Building your own version of OpenCV
===================================

You probably just want to use the compiled version on our releases page or from
our opkg feed. This build has only been tested on Linux using docker as directed
below.

Build steps
-----------

First, install [docker](https://docs.docker.com/). Then run:

    ./launch.sh

This will give you a shell in the docker container. You can then run:

    ./fetch.sh
    ./build.sh

If you're building on your own Linux host that has cmake and the FRC toolchain
installed, you can probably just execute the following:

    ./fetch.sh
    ./build.sh

But... I'd recommend using the docker image instead.

Troubleshooting
---------------

* `zlib.h: No such file or directory`: For some reason if zlib1g-dev is
  installed on the system, the cmake included with Ubuntu 14.04 messes up
  the configuration and it breaks. Uninstall zlib1g-dev and it will work.

Contributing new changes
========================

This is intended to be a project that all members of the FIRST community can
quickly and easily contribute to. If you find a bug, or have an idea that you
think others can use:

1. [Fork this git repository](https://github.com/robotpy/roborio-opencv/fork) to your github account
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push -u origin my-new-feature`)
5. Create new Pull Request on github
