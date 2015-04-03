# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  MEM = 2048
  CPUS = 1

  config.vm.provider "virtualbox" do |v|

    # Taken from https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck#toc_3
    host = RbConfig::CONFIG['host_os']
    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      CPUS = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      MEM = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      CPUS = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      MEM = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      CPUS = 2
      MEM = 1024
    end

    v.customize ["modifyvm", :id, "--memory", MEM]
    v.customize ["modifyvm", :id, "--cpus", CPUS]
  end

  config.vm.provider "vmware_workstation" do |vm|
    vm.vmx["memsize"] = MEM.to_s
    vm.vmx["numvcpus"] = CPUS.to_s
  end
end

  config.vm.define "vbox_standard" do |vbs|
    vbs.vm.box = "chef/ubuntu-14.04"
    vbs.vm.network "private_network", type: "dhcp"
    vbs.vm.synced_folder "states", "/srv/salt"
    vbs.vm.synced_folder "pillars", "/srv/pillar"
    vbs.vm.provision :salt do |salt|
      salt.minion_config = "minion"
      salt.log_level = 'error'
      salt.colorize = false
      salt.run_highstate = true
    end
  end

  config.vm.define "vbox_nfs" do |vbn|
    vbn.vm.box = "chef/ubuntu-14.04"
    vbn.vm.network "private_network", type: "dhcp"
    vbn.vm.synced_folder "states", "/srv/salt", nfs: true
    vbn.vm.synced_folder "pillars", "/srv/pillar", nfs: true
    vbn.vm.provision :salt do |salt|
      salt.minion_config = "minion"
      salt.log_level = 'error'
      salt.colorize = false
      salt.run_highstate = true
    end
  end

  config.vm.define "vmware" do |vmw|
    vmw.vm.box = "chef/ubuntu-14.04"
    vmw.vm.network "private_network", type: "dhcp"
    vmw.vm.synced_folder "states", "/srv/salt"
    vmw.vm.synced_folder "pillars", "/srv/pillar"
    vmw.vm.provision :salt do |salt|
      salt.minion_config = "minion"
      salt.log_level = 'error'
      salt.colorize = false
      salt.run_highstate = true
    end
  end
end
