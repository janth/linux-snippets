#!/bin/bash

uname -r

dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs echo sudo apt-get -y purge

find /lib/modules -depth -type d -empty -exec echo sudo rmdir '{}' \;

dpkg --list | grep "^rc" | cut -d " " -f 3 | grep "^linux-" | xargs echo sudo dpkg --purge

echo
KERN_VER=`uname -r` ; KERN_DIR="/lib/modules/$KERN_VER/build"
KERN_REL=`make -sC $KERN_DIR --no-print-directory kernelrelease 2>/dev/null || true`
if [ -z "$KERN_REL" -o "x$KERN_REL" = "x$KERN_VER" ]; then
   echo "OK: $KERN_VER = $KERN_REL, -> $KERN_DIR"
else
   echo "ERR: $KERN_VER != $KERN_REL, -> $KERN_DIR"
fi

xver=`X -version 2>&1`
x_version=`echo "$xver" | sed -n 's/^X Window System Version \([0-9.]\+\)/\1/p'``echo "$xver" | sed -n 's/^XFree86 Version \([0-9.]\+\)/\1/p'``echo "$xver" | sed -n 's/^X Protocol Version 11, Revision 0, Release \([0-9.]\+\)/\1/p'``echo "$xver" | sed -n 's/^X.Org X Server \([0-9.]\+\)/\1/p'`
x_version_short=`echo "${x_version}" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/'`
echo "X: $x_version, $x_version_short"


 : << X

# https://linuxprograms.wordpress.com/2010/05/11/status-dpkg-list/

First character: The possible value for the first character. The first character signifies the desired state, like we (or some user) is marking the package for installation

    u: Unknown (an unknown state)
    i: Install (marked for installation)
    r: Remove (marked for removal)
    p: Purge (marked for purging)
    h: Hold

Second Character: The second character signifies the current state, whether it is installed or not. The possible values are

    n: Not- The package is not installed
    i: Inst – The package is successfully installed
    c: Cfg-files – Configuration files are present
    u: Unpacked- The package is stilled unpacked
    f: Failed-cfg- Failed to remove configuration files
    h: Half-inst- The package is only partially installed
    W: trig-aWait
    t: Trig-pend

Let’s move to the third character
Third Character: This corresponds to the error state. The possible value include

    R: Reinst-required The package must be installed.

X
