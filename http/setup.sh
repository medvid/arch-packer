#!/bin/sh
set -ex
http_root="$1"
shift

# partitioning
fdisk /dev/sda <<EOF
o
n
p
1

+512M
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

# Add package signing key
keyid=95A453CD
pacman-key -r $keyid
pacman-key --lsign-key $keyid

# Disable all repositories
sed -i -e 's/^\([^#]\)/#\1/g' /etc/pacman.d/mirrorlist

# Add local repository + 10 fastest mirrors
cat >> /etc/pacman.d/mirrorlist <<EOF
Server = $http_root/\$arch
Server = http://ftp.linux.kiev.ua/pub/Linux/ArchLinux/\$repo/os/\$arch
Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = http://ftp.mfa.kfki.hu/pub/mirrors/ftp.archlinux.org/\$repo/os/\$arch
Server = http://mir.archlinux.fr/\$repo/os/\$arch
Server = http://ftp5.gwdg.de/pub/linux/archlinux/\$repo/os/\$arch
Server = http://ftp.tu-chemnitz.de/pub/linux/archlinux/\$repo/os/\$arch
Server = http://ftp.eenet.ee/pub/archlinux/\$repo/os/\$arch
Server = http://mirror.aarnet.edu.au/pub/archlinux/\$repo/os/\$arch
Server = http://ftp.heanet.ie/mirrors/ftp.archlinux.org/\$repo/os/\$arch
Server = http://mirror.nl.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://ftp.nluug.nl/pub/os/Linux/distr/archlinux/\$repo/os/\$arch
EOF

pacstrap /mnt base base-devel
genfstab -p /mnt >> /mnt/etc/fstab

# Add local repository
cat >> /mnt/etc/pacman.conf <<EOF

[local]
SigLevel = Never
Server = $http_root/\$arch
EOF

setup_chroot=/root/setup-chroot.sh
curl -o /mnt/$setup_chroot "$http_root/setup-chroot.sh"
chmod +x /mnt/$setup_chroot
arch-chroot /mnt $setup_chroot

rm /mnt/$setup_chroot

# unmount partitions
umount /mnt
swapoff /dev/sda1

reboot
