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