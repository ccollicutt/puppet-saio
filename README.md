#Puppet SAIO - Deploy OpenStack Swift all-in-one

This repository contains the code to deploy [OpenStack Swift All-in-one](http://docs.openstack.org/developer/swift/development_saio.html) (SAIO) using Puppet.

This puppet module is also located on [Puppet Forge](https://forge.puppetlabs.com/serverascode/saio).

##Using

The idea of this repository is to check it out and run vagrant up:

```
$ git clone git@github.com:curtisgithub/puppet-saio.git
$ vagrant up
```

and have OpenStack Swift deployed from source, either the offical repositories or your own repo. Any more than that is a bug, so please feel free to let me know if it doesn't work as expected.

###Parameters

Currently the SAIO class takes four parameters, which are shown below with their defaults:

```
$swiftuser='vagrant', 
$swiftgroup='vagrant',
$swiftclient_repo='https://github.com/openstack/python-swiftclient.git',
$swift_repo='https://github.com/openstack/swift.git'
```

So you an change those in the nodes.pp file to whatever you prefer.

## Puppet

### shell inline

In the Vagrant file the puppet.sh script is run, and also a couple of inline shell commands, one of which installs [vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo) which is a dependancy of puppet-saio.

### puppet.sh

The puppet.sh script will install puppet 3+, though puppet does come with Vagrant, just an older version. I would expect that the Vagrant puppet would work fine though.

## Development environment

* Puppet 3.3.2
* OSX 10.8.2
* Virtualbox 4.2.6
* Vagrant 1.3.5
* Ubuntu 12.04 for the vm