#!/bin/sh
set -ex

# Hostname
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

# Update pacman databases
pacman -Sy

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

systemctl enable vboxservice

# User account
user=vmm
password=vmm

pacman -S --noconfirm sudo zsh
useradd -m -g users -s /usr/bin/zsh $user
echo -e "$password\n$password\n" | passwd $user
echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/$user
chmod 0440 /etc/sudoers.d/$user

# Vagrant
echo -e 'vagrant\nvagrant\n' | passwd
useradd -m -g users vagrant
echo -e 'vagrant\nvagrant\n' | passwd vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Gnome-keyring
pacman -S --noconfirm gnome-keyring libgnome-keyring
sed -i -e '/auth[ \t]*include[ \t]*system-local-login/a \
auth       optional     pam_gnome_keyring.so' /etc/pam.d/login
sed -i -e '/session[ \t]*include[ \t]*system-local-login/a \
session    optional     pam_gnome_keyring.so        auto_start' /etc/pam.d/login
echo 'password        optional        pam_gnome_keyring.so' >> /etc/pam.d/passwd

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
pacman -S --noconfirm antiword asciidoc antiword aria2 bc cabextract calc \
  catdoc dos2unix graphviz htop imagemagick lesspipe libnotify lsof lynx \
  markdown mc mpg123 ranger rlwrap rsync sysstat tmux tree unrar unzip \
  vifm vbindiff w3m wget xmlto zip

# Internationalization
pacman -S --noconfirm aspell-en aspell-ru aspell-uk libmythes mythes-en \
  hunspell hunspell-en hyphen hyphen-en

# Fonts
pacman -S --noconfirm ttf-bitstream-vera ttf-dejavu ttf-droid \
  ttf-ubuntu-font-family

# Themes
pacman -S --noconfirm gtk-engine-murrine numix-themes xcursor-vanilla-dmz

# Xorg
pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit

# X utilities
pacman -S --noconfirm dunst gmrun numlockx slock unclutter wmctrl \
  xautolock xdotool xorg-xev xorg-xprop xsel

# Applications
pacman -S --noconfirm emacs feh firefox flashplugin gcolor2 gitg gnuplot \
  gucharmap gvim meld p7zip qtcreator sbxkb seahorse spacefm sxiv zathura \
  zathura-djvu zathura-pdf-poppler zathura-ps

# Libreoffice
pacman -S --noconfirm libreoffice-base libreoffice-calc libreoffice-common \
  libreoffice-draw libreoffice-gnome libreoffice-impress libreoffice-math \
  libreoffice-writer libreoffice-en-US

# Packages from local repository
pacman -S --noconfirm bspwm cower dmenu-xft electricfence hunspell-ru \
  hunspell-uk hyphen-ru hyphen-uk rxvt-unicode-patched simpleswitcher-git \
  sxhkd trayer-srg

# Remove local mirror
sed -i '/^Server = http:\/\/10\./d' /etc/pacman.d/mirrorlist
# Replace local repository address
sed -i '$d' /etc/pacman.conf
cat >> /etc/pacman.conf <<EOF
Server = file:///home/vmm/dev/projects/pkgbuild/\$repo/os/\$arch
EOF
