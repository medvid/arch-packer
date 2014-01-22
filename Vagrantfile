# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "arch_x64"

  # config.vm.network :private_network, ip: "192.168.56.11"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.name = "arch_x64_11"

    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    vb.customize ["sharedfolder", "add", :id, "--name", "D_DRIVE", "--hostpath", "D:/"]
  end

  config.vm.provision "shell", path: "scripts/base.sh"
  config.vm.provision "shell", path: "scripts/devel.sh"
  config.vm.provision "shell", path: "scripts/network.sh"
  config.vm.provision "shell", path: "scripts/user.sh"
end
