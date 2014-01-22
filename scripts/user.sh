#!/bin/sh
set -x

user=vmm
password=vmm

useradd -m -g users -s /usr/bin/zsh $user
echo -e "$password\n$password\n" | passwd $user
echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/$user
chmod 0440 /etc/sudoers.d/$user
