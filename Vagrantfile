# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "x86" do |x86|
    x86.vm.box = "arch_x86"
    x86.vm.provider :virtualbox do |vb|
      vb.name = "arch_x86_10"
    end
  end

  config.vm.define "x64" do |x64|
    x64.vm.box = "arch_x64"
    x64.vm.provider :virtualbox do |vb|
      vb.name = "arch_x64_20"
    end
    x64.vm.provision "shell", path: "scripts/multilib.sh"
  end

  config.vm.provider :virtualbox do |vb|
    vb.gui = true

    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    if (RUBY_PLATFORM =~ /mswin|mingw|cygwin/)
      vb.customize ["modifyvm", :id, "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"]
      vb.customize ["sharedfolder", "add", :id, "--name", "D_DRIVE", "--hostpath", "D:/"]
    else
      vb.customize ["modifyvm", :id, "--hostonlyadapter2", "vboxnet0"]
      vb.customize ["sharedfolder", "add", :id, "--name", "SHARE", "--hostpath", "/mnt/share"]
    end
  end

  if (RUBY_PLATFORM =~ /mswin|mingw|cygwin/)
    config.vm.provision "shell", path: "scripts/vbox-windows.sh"
  else
    config.vm.provision "shell", path: "scripts/vbox-linux.sh"
  end

  config.vm.provision "shell", path: "scripts/network.sh"
end
