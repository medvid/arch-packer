#!/bin/sh
set -x

cat >> /etc/fstab <<EOF
SHARE /mnt/share vboxsf uid=root,gid=users,fmode=770,dmode=770,noauto,x-systemd.automount 0 0
EOF

mkdir -p -m770 /mnt/share
chown root:users /mnt/share
