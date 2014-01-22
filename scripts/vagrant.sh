#!/bin/sh
set -ex

mkdir -p -m700 ~/.ssh
curl -o ~/.ssh/authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 600 ~/.ssh/authorized_keys
