#!/bin/sh
set -ex

# Setup user account
user=vmm
password=vmm

useradd -m -g users -G vboxsf -s /usr/bin/zsh $user
echo -e "$password\n$password\n" | passwd $user
echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/$user
chmod 0440 /etc/sudoers.d/$user

# LightDM autologin
groupadd autologin
gpasswd -a $user autologin
sed -i "s/^#\(autologin-user=\)$/\1$user/g" /etc/lightdm/lightdm.conf
sed -i "s/^#\(autologin-user-timeout=0\)$/\1/g" /etc/lightdm/lightdm.conf
