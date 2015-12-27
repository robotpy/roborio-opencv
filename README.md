OpenCV build for RoboRIO
========================

This is a set of scripts that will build OpenCV for the RoboRIO with bindings for:

* C++
* Python 2.7.11
* Python 3.5.0
* Java

The result of the compilation process is a zipfile that can be turned into IPK
files using the [roborio-packages](https://github.com/robotpy/roborio-packages)
repository.

RoboRIO Installation
====================

The easiest way to install these packages is to set up the RobotPy opkg feed
on your RoboRIO. Create a `.conf` file in `/etc/opkg` (e.g. `/etc/opkg/robotpy.conf`)
containing the following line:

    src/gz robotpy http://www.tortall.net/~robotpy/feeds/2016

Once the feed is added, issue an `opkg update` and then you can install
packages using the following commands (requires internet access).

For Python2:

    opkg install python27-opencv
    
For Python3:

    opkg install python35-opencv

For C++:

    opkg install opencv3
    
For Java:

    opkg install opencv3-java

Offline Installation
--------------------

TODO: The RobotPy installer should be able to do this in the near future

Manual Installation
-------------------

TODO: document this

Usage
=====

For detailed information about OpenCV, see their [website](http://opencv.org/).
There's lots of documentation and tutorials/etc available.

Using the C++ and Java bindings
-------------------------------

Download the [latest release](https://github.com/robotpy/roborio-vm/releases)
and point your compiler at the right bits in the included files.

* TODO: document this, create a better release package

Using the Python bindings
-------------------------

Just develop the code as you normally would, copy the python files over to the
RoboRIO, and it should just work.

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
