OpenCV 3.3.0 build for RoboRIO
==============================

This is a set of scripts that will build OpenCV for the RoboRIO with bindings for:

* C++
* Python 3.6.0
* ~~Java~~ (currently broken, but FIRST provides that so I'm not going to fix it)

The result of the compilation process is a zipfile that can be turned into IPK
files using the [roborio-packages](https://github.com/robotpy/roborio-packages)
repository.

**NOTE**: For 2017, OpenCV 3.1.0 is well-supported for C++ and Java by WPILib,
so if you're looking to use those languages you should use their stuff instead.

RoboRIO Installation
====================

The easiest way to install these packages is to set up the RobotPy opkg feed
on your RoboRIO. Create a `.conf` file in `/etc/opkg` (e.g. `/etc/opkg/robotpy.conf`)
containing the following line:

    src/gz robotpy http://www.tortall.net/~robotpy/feeds/2017

Once the feed is added, issue an `opkg update` and then you can install
packages using the following commands (requires internet access).

For Python3:

    opkg install python36-opencv3

For C++:

    opkg install opencv3

~~For Java (Java programming support must be installed separately)~~:

    opkg install opencv3-java

Offline Installation
--------------------

You can use the [RobotPy Installer Script](https://github.com/robotpy/robotpy-wpilib/blob/master/installer/installer.py)
to do offline opkg installs. First, download the package:

    python3 installer.py download-opkg opencv3

Then, connect to the network with the RoboRIO, and install it:

    python3 installer.py install-opkg opencv3

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
our opkg feed. This build has only been tested on Ubuntu 14.04 using the
included VM configuration.

Build steps
-----------

First, install [Vagrant](https://www.vagrantup.com/). Then...

    vagrant up
    vagrant ssh
    sudo /vagrant/fetch.sh
    /vagrant/build.sh

If you're building on your own Linux host, you can probably just execute the
following:

    sudo ./fetch.sh
    ./build.sh

But... I'd recommend using the VM instead.

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
