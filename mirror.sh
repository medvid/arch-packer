#!/bin/sh

ROOTDIR=`dirname $0`

arch=`uname -m`
dest="$ROOTDIR/http/$arch"

src_db=/var/lib/pacman/sync
src_pkg=/var/cache/pacman/pkg

mkdir -p $dest
cp -vn $src_db/* $src_pkg/* $dest
