# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  mem = nil
  cpus = nil

  config.vm.provider "virtualbox" do |v|

    # Taken from https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck#toc_3
    host = RbConfig::CONFIG['host_os']
    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 1024
    end

    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--cpus", cpus]
  end

  config.vm.provider "vmware_workstation" do |vm|
    vm.vmx["memsize"] = mem.to_s
    vm.vmx["numvcpus"] = cpus.to_s
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
    vmw.vm.box = "tfield/trusty64"
    vmw.vm.network "public_network"
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
