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

## Tips & Tweaks

* To disable annoying VirtualBox notifications forever:

    ```sh
    VBoxManage setextradata global "GUI/SuppressMessages" "all"
    ```

  Please make sure VirtualBox is not running while executing this command.

* If your processor does not support hardware virtualization (VT-x),
  you should add the following string to `arch_x86.json`:

    ```js
    ["modifyvm", "{{.Name}}", "--hwvirtex", "off"]
    ```
  More info [here](http://piotr.banaszkiewicz.org/blog/2012/06/10/vagrant-lack-of-hvirt/).
