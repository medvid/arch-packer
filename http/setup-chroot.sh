#!/bin/sh
set -ex

# Hostname
# TODO: arch_x32/64
echo arch.local > /etc/hostname

# Timezone
ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime

# Locale
cat > /etc/locale.conf <<EOF
LANG="en_US.UTF-8"
LC_COLLATE="C"
EOF
sed -i -e 's/^#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen
locale-gen

# Vagrant
pacman -S --noconfirm sudo
echo -e 'vagrant\nvagrant\n' | passwd
useradd -m -g users vagrant
echo -e 'vagrant\nvagrant\n' | passwd vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Network
# disable persistent network names
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
systemctl enable dhcpcd@eth0

# SSH
pacman -S --noconfirm openssh
# Make sure SSH is allowed
echo "sshd: ALL" > /etc/hosts.allow
# And everything else isn't
echo "ALL: ALL" > /etc/hosts.deny
# Make sure sshd starts on boot
systemctl enable sshd
/usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

# Bootloader
pacman -S --noconfirm syslinux
cp -r /usr/lib/syslinux/bios/* /boot/syslinux
extlinux --install /boot/syslinux
printf "\x2" | cat /usr/lib/syslinux/bios/altmbr.bin - | \
  dd bs=440 count=1 iflag=fullblock conv=notrunc of=/dev/sda

cat > /boot/syslinux/syslinux.cfg <<EOF
DEFAULT arch
PROMPT 0
TIMEOUT 10

UI menu.c32
MENU TITLE Arch Linux
MENU HIDDEN
MENU AUTOBOOT

LABEL arch
MENU LABEL Arch Linux
LINUX ../vmlinuz-linux
APPEND root=/dev/sda2 rw quiet loglevel=0 vga=current
INITRD ../initramfs-linux.img

LABEL archfallback
MENU LABEL Arch Linux Fallback
LINUX ../vmlinuz-linux
APPEND root=/dev/sda2 rw
INITRD ../initramfs-linux-fallback.img
EOF

# Virtualbox
pacman --noconfirm -S virtualbox-guest-utils
cat > /etc/modules-load.d/vbox.conf <<EOF
vboxguest
vboxsf
vboxvideo
EOF

cat >> /etc/fstab <<EOF
D_DRIVE /mnt/d vboxsf uid=root,gid=users,fmode=770,dmode=770,noauto,x-systemd.automount 0 0
EOF

mkdir -p -m770 /mnt/d

systemctl daemon-reload
systemctl enable vboxservice

# Base packages
pacman -S --noconfirm mc zsh

# Development packages
pacman  -S --noconfirm base-devel ack gdb git
