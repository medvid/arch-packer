#!/bin/sh
set -x

sudo sh -c 'cat >> /etc/fstab <<EOF
D_DRIVE /mnt/d vboxsf uid=root,gid=users,fmode=770,dmode=770,noauto,x-systemd.automount 0 0
EOF'

sudo mkdir -p -m770 /mnt/d
sudo chown root:users /mnt/d
