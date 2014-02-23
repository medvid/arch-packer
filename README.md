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

## Post-installation steps

* Login as normal user (username: vmm, password: vmm)

* Change user password

* Install ssh keys

* Install repositories

    ```sh
    git clone git://github.com:medvid/dotfiles.git ~/dev/projects/dotfiles
    ~/dev/projects/dotfiles/install.sh
    ```

* Logout and login on tty1. Development environment is now ready.

## Tips & Tweaks

* You can setup local repository mirror to avoid package downloading
  everytime you run packer build. To do this, run `mirror.sh`
  on existent Archlinux machine. Package mirror will be created
  in `http/$arch` directory.

* You should sign all packages in local mirror with `sign.sh`.
  Please enter your GPG key ID in `http/setup.sh`.

* I dont use AUR helpers. All AUR packages should be prebuilt in local
  repository. You can build them from my [pkgbuild][1] repository:

    ```sh
    git clone https://github.com/medvid/pkgbuild.git && cd pkgbuild
    # build packages
    ./build.sh
    cp -nv local/os/$arch/* $this_repo/http/$arch
    # build database
    ./db.sh
    cp local/os/$arch/local.db.tar.gz $this_repo/http/$arch/local.db
    ```

  Don't forget to sign these packages.

* To update local package databases from server, please run
  `db.sh` script.

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

  Also, you may need to set cpus number to 1:

    ```js
    ["modifyvm", "{{.Name}}", "--cpus", "1"]
    ```

  More info [here][2].

[1]: https://github.com/medvid/pkgbuild
[2]: http://piotr.banaszkiewicz.org/blog/2012/06/10/vagrant-lack-of-hvirt/
