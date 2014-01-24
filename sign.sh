#!/bin/bash

force=0

for opt do
  optarg=`expr "x$opt" : 'x[^=]*=\(.*\)'`
  case "$opt" in
  -f|--force)
    force=1
    ;;
  --no-force)
    force=0
    ;;
  esac
done

dir=`dirname $0`

for pkg in `ls $dir/http/{i686,x86_64}/*.xz`; do
  if [[ $force -eq 1 ]]; then
    rm -f $pkg.sig
  fi
  if [[ ! -e $pkg.sig ]]; then
    gpg --detach-sign --use-agent $pkg
  fi
done
