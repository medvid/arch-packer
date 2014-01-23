#!/bin/sh

dir=`dirname $0`

for pkg in `ls $dir/http/{i686,x86_64}/*.xz`; do
  if [ ! -e $pkg.sig ]; then
    gpg --detach-sign --use-agent $pkg
  fi
done
