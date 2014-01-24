#!/bin/sh

http_root=`dirname $0`/http

mirror="http://ftp.linux.kiev.ua/pub/Linux/ArchLinux"

get_db() {
  local repo=$1
  local arch=$2
  local dir=$http_root/$arch

  echo "Update $arch/$repo"
  mkdir -p $dir
  wget $mirror/$repo/os/$arch/$repo.db -O $dir/$repo.db --quiet
}

# update repository databases
for arch in i686 x86_64; do
  for repo in core extra community; do
    get_db $repo $arch
  done
done
get_db multilib x86_64

# update symlinks to local databases
for arch in i686 x86_64; do
  dir=$http_root/$arch

  if [ ! -e $dir/local.db ]; then
    if [ -e $dir/local.db.tar.gz ]; then
      ln -s local.db.tar.gz $dir/local.db
    else
      echo "Warning: database $dir/local.db.tar.gz does not exist!"
    fi
  fi
done
