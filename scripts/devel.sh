#!/bin/sh
set -x

pacman -S --noconfirm base-devel ack gdb git

# TODO: multilib-devel
# * add repo
# * silently replace base-devel
