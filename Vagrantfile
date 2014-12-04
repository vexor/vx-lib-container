# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"

  config.ssh.private_key_path = "~/.ssh/id_rsa"
  config.ssh.pty = true

  config.vm.provider :rackspace do |rs|
    rs.username          = ENV['SDK_USERNAME']
    rs.api_key           = ENV['SDK_TOKEN']
    rs.flavor            = /4 GB/
    rs.image             = /Ubuntu 14.04/
    rs.rackspace_region  = ENV['SDK_REGION']
    rs.key_name          = ENV['SDK_KEYNAME']
    rs.server_name       = 'vx.lib.container.build'
  end

  script = <<SCRIPT
/vagrant/scripts/box_up.sh
SCRIPT

  config.vm.provision "shell", inline: script
end
