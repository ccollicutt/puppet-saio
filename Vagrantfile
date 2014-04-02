# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "192.168.33.150"

  #
  # Install puppet > 3
  #

  config.vm.provision :shell, :path => 'puppet.sh'

  config.vm.provider :virtualbox do |vb|
    # Fixes a problem with DNS in the guest
    vb.customize [
      "modifyvm", :id,
      "--memory", 4096,
      ]
  end

  #
  # Now that puppet > 3 is installed, download a couple of required modules
  # then run puppet-saio.
  #

  config.vm.provision :shell do |shell|
    shell.inline = "mkdir -p /etc/puppet/modules;
                    puppet module install puppetlabs/vcsrepo; 
                    puppet module install puppetlabs/stdlib;
                    puppet apply --user vagrant --modulepath=/etc/puppet/modules:/vagrant/modules --manifestdir /vagrant/manifests --detailed-exitcodes /vagrant/manifests/site.pp"
  end
end
