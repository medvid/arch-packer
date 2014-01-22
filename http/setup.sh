#!/bin/sh
set -ex
http_root="$1"
shift

# set preferred mirror
# passed to sed expression, so should escape '/' and '$'
MIRROR="http:\/\/ftp.linux.kiev.ua\/pub\/Linux\/ArchLinux\/\$repo\/os\/\$arch"

# size of swap partition
SWAPSIZE=512M

# partitioning
# /dev/sda1 swap SWAPSIZE
fdisk /dev/sda <<EOF
o
n
p
1

+$SWAPSIZE
t
82
n
p
2


t
2
83
w
EOF

# format partitions
mkswap -L swap /dev/sda1
mkfs.ext4 -m 1 -q -L root /dev/sda2

# mount partitions
swapon /dev/sda1
mount /dev/sda2 /mnt

# insert preferred mirror after the first empty line in mirrorlist
sed -i "0,/^$/s//\nServer = $MIRROR\n/" /etc/pacman.d/mirrorlist

pacstrap /mnt base
genfstab -p /mnt >> /mnt/etc/fstab

setup_chroot=/root/setup-chroot.sh
curl -o /mnt/$setup_chroot "$http_root/setup-chroot.sh"
chmod +x /mnt/$setup_chroot
arch-chroot /mnt $setup_chroot

rm /mnt/$setup_chroot

# unmount partitions
umount /mnt
swapoff /dev/sda1

reboot
