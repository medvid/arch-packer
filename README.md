# Packer template for Arch Linux Vagrant box

- http://www.packer.io/
- http://www.vagrantup.com/

## 32-bit guest

```sh
packer build arch_x32.json
vagrant box remove arch_x32 # for update
vagrant box add arch_x32 arch_x32.box
vagrant up
vagrant ssh
# username: vagrant, password: vagrant
```

## 64-bit guest

```sh
packer build arch_x64.json
vagrant box remove arch_x64 # for update
vagrant box add arch_x64 arch_x64.box
vagrant up
vagrant ssh
# username: vagrant, password: vagrant
```
