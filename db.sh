#!/bin/sh

http_root=`dirname $0`/http

mirror="http://ftp.linux.kiev.ua/pub/Linux/ArchLinux"

get_db() {
  local repo=$1
  local arch=$2
  local dir=$http_root/$arch

  mkdir -p $dir
  wget $mirror/$repo/os/$arch/$repo.db -O $dir/$repo.db
}

for repo in core extra community; do
  for arch in i686 x86_64; do
    get_db $repo $arch
  done
done
get_db multilib x86_64
