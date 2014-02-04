#!/bin/sh
set -x

# Uncomment multilib repository in pacman.conf
awk -i inplace '
/^#\[multilib\]/{s=1}
s>0{sub("^#","");s++}
s==3{s=0}
{print}
' /etc/pacman.conf

# Install multilib-devel group, replacing packages from base-devel
# --noconfirm does not work here
# 6 confirmations should be done:
#   - select all packages in group (RET)
#   - binutils (y)
#   - gcc-libs (y)
#   - gcc (y)
#   - libtool (y)
#   - pacman summary (y)
echo -ne '\ny\ny\ny\ny\ny\n' | pacman -Sy multilib-devel
