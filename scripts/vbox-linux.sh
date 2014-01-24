#!/bin/sh
set -x

sudo sh -c 'cat >> /etc/fstab <<EOF
SHARE /mnt/share vboxsf uid=root,gid=users,fmode=770,dmode=770,noauto,x-systemd.automount 0 0
EOF'

sudo mkdir -p -m770 /mnt/share
