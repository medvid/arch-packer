#!/bin/sh
set -ex

# Hostname
echo arch > /etc/hostname

# Timezone
ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime

# Locale
cat > /etc/locale.conf <<EOF
LANG="en_US.UTF-8"
LC_COLLATE="C"
EOF
sed -i -e 's/^#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen
locale-gen

# Update pacman databases
pacman -Sy

# Network
# disable persistent network names
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
cat > /etc/netctl/eth0 << EOF
Description='DHCP ethernet connection'
Interface=eth0
Connection=ethernet
IP=dhcp
IP6=no
EOF
netctl enable eth0

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
cp /usr/lib/syslinux/bios/{menu.c32,memdisk,ldlinux.c32,libcom32.c32,libutil.c32} /boot/syslinux
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
systemctl enable vboxservice

# Vagrant
pacman -S --noconfirm sudo
echo -e 'vagrant\nvagrant\n' | passwd
useradd -m -g users -G vboxsf vagrant
echo -e 'vagrant\nvagrant\n' | passwd vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Development packages
pacman -S --noconfirm ack autogen bash-completion bashdb boost clang \
  clang-analyzer clang-tools-extra cmake ctags dash dejagnu doxygen gdb \
  git linux-headers ltrace mercurial nasm nodejs subversion strace tcl \
  tcsh the_silver_searcher tig tk valgrind yasm zshdb zsh-completions \
  zsh-syntax-highlighting

# Documentation
pacman -S --noconfirm bash-docs gcc-docs linux-docs linux-howtos \
  man-pages-ru ruby-docs zsh-doc

# Networking
pacman -S --noconfirm dnsutils fping tcpdump traceroute vnstat whois

# Utilities
pacman -S --noconfirm asciidoc antiword aria2 bc cabextract calc catdoc \
  dos2unix htop imagemagick lesspipe libnotify lsof lynx markdown mc \
  mpg123 ranger rlwrap rsync sysstat tmux tree unrar unzip vifm \
  vbindiff w3m wget xmlto zip zsh

# Internationalization
pacman -S --noconfirm aspell-en aspell-ru aspell-uk libmythes mythes-en \
  hunspell hunspell-en hyphen hyphen-en

# Fonts
pacman -S --noconfirm ttf-bitstream-vera ttf-dejavu ttf-droid \
  ttf-ubuntu-font-family

# Themes
pacman -S --noconfirm numix-themes

# Xorg
pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit

# X utilities
pacman -S --noconfirm awesome gmrun numlockx vicious xorg-xprop xsel

# Applications
pacman -S --noconfirm firefox flashplugin gcolor2 gitg gnuplot \
  graphviz gucharmap gvim keychain meld p7zip qtcreator spacefm \
  viewnior zathura zathura-djvu zathura-pdf-poppler zathura-ps

# Packages from local repository
pacman -S --noconfirm cower dmenu-xft electricfence hunspell-ru \
  hunspell-uk hyphen-ru hyphen-uk simpleswitcher-git termite-git

# Cleanup pacman cache to reduce image size
pacman -Sc --noconfirm

# Remove local mirror
sed -i '/^Server = http:\/\/10\./d' /etc/pacman.d/mirrorlist
# Replace local repository address
sed -i '$d' /etc/pacman.conf
cat >> /etc/pacman.conf <<EOF
Server = file:///home/vmm/dev/projects/pkgbuild/\$repo/os/\$arch
EOF
