# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "x86" do |x86|
    x86.vm.box = "arch_x86"
    # x86.vm.network :private_network, ip: "192.168.56.10"
    x86.vm.provider :virtualbox do |vb|
      vb.name = "arch_x86_10"
    end
  end

  config.vm.define "x64" do |x64|
    x64.vm.box = "arch_x64"
    # x64.vm.network :private_network, ip: "192.168.56.20"
    x64.vm.provider :virtualbox do |vb|
      vb.name = "arch_x64_20"
    end
  end

  config.vm.provider :virtualbox do |vb|
    vb.gui = true

    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    vb.customize ["sharedfolder", "add", :id, "--name", "D_DRIVE", "--hostpath", "D:/"]
  end

  # config.vm.provision "shell", path: "scripts/base.sh"
  # config.vm.provision "shell", path: "scripts/devel.sh"
  # config.vm.provision "shell", path: "scripts/network.sh"
  # config.vm.provision "shell", path: "scripts/user.sh"
end
