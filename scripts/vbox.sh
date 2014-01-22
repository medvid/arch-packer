#!/bin/sh
set -ex

sudo pacman --noconfirm -S virtualbox-guest-utils
sudo sh -c 'cat > /etc/modules-load.d/vbox.conf <<EOF
vboxguest
vboxsf
vboxvideo
EOF'

sudo sh -c 'cat >> /etc/fstab <<EOF
D_DRIVE /mnt/d vboxsf uid=root,gid=users,fmode=770,dmode=770,noauto,x-systemd.automount 0 0
EOF'

sudo mkdir -p -m770 $path

sudo systemctl daemon-reload
sudo systemctl enable vboxservice
