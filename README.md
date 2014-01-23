# Packer template for Arch Linux Vagrant box

- http://www.packer.io/
- http://www.vagrantup.com/

## 32-bit guest

```sh
packer build arch_x86.json
vagrant box remove arch_x86 # for update
vagrant box add arch_x86 arch_x86.box
vagrant up x86
vagrant ssh x86
# username: vagrant, password: vagrant
```

## 64-bit guest

```sh
packer build arch_x64.json
vagrant box remove arch_x64 # for update
vagrant box add arch_x64 arch_x64.box
vagrant up x64
vagrant ssh x64
# username: vagrant, password: vagrant
```
