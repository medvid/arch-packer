#!/bin/sh
set -x

sudo awk -i inplace '
/^#\[multilib\]/{s=1}
s>0{sub("^#","");s++}
s==3{s=0}
{print}
' /etc/pacman.conf

# --noconfirm doesn't work here
yes | sudo pacman -Sy --noconfirm multilib-devel
