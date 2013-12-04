#Puppet SAIO - Deploy OpenStack Swift all-in-one

This repository contains the code to deploy [OpenStack Swift All-in-one](http://docs.openstack.org/developer/swift/development_saio.html) (SAIO) using Puppet.

This module is also on [Puppet Forge](https://forge.puppetlabs.com/serverascode/saio).

##Using

The idea of this repository is to check it out and run vagrant up:

```
$ git clone git@github.com:curtisgithub/puppet-saio.git
$ vagrant up
```

and have OpenStack Swift deployed from source, either the official repositories or your own repo. Any more than that is a bug, so please feel free to let me know if it doesn't work as expected.

###Parameters

Currently the SAIO class takes four parameters, which are shown below with their defaults:

```
$swiftuser='vagrant', 
$swiftgroup='vagrant',
$swiftclient_repo='https://github.com/openstack/python-swiftclient.git',
$swift_repo='https://github.com/openstack/swift.git'
```

So you an change those in the nodes.pp file to whatever you prefer.

###Post-install

Once puppet has run there are a couple of bash scripts that need to be run.

First ssh into the virtual machine:

```
$ vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:23:18 2012 from 10.0.2.2
vagrant@precise64:~$ 
```

Next (re)make the rings:

```
vagrant@precise64:~$ remakerings 
Device d0r1z1-127.0.0.1:6010R127.0.0.1:6010/sdb1_"" with 1.0 weight got id 0
Device d1r1z2-127.0.0.1:6020R127.0.0.1:6020/sdb2_"" with 1.0 weight got id 1
Device d2r1z3-127.0.0.1:6030R127.0.0.1:6030/sdb3_"" with 1.0 weight got id 2
Device d3r1z4-127.0.0.1:6040R127.0.0.1:6040/sdb4_"" with 1.0 weight got id 3
Reassigned 1024 (100.00%) partitions. Balance is now 0.00.
Device d0r1z1-127.0.0.1:6011R127.0.0.1:6011/sdb1_"" with 1.0 weight got id 0
Device d1r1z2-127.0.0.1:6021R127.0.0.1:6021/sdb2_"" with 1.0 weight got id 1
Device d2r1z3-127.0.0.1:6031R127.0.0.1:6031/sdb3_"" with 1.0 weight got id 2
Device d3r1z4-127.0.0.1:6041R127.0.0.1:6041/sdb4_"" with 1.0 weight got id 3
Reassigned 1024 (100.00%) partitions. Balance is now 0.00.
Device d0r1z1-127.0.0.1:6012R127.0.0.1:6012/sdb1_"" with 1.0 weight got id 0
Device d1r1z2-127.0.0.1:6022R127.0.0.1:6022/sdb2_"" with 1.0 weight got id 1
Device d2r1z3-127.0.0.1:6032R127.0.0.1:6032/sdb3_"" with 1.0 weight got id 2
Device d3r1z4-127.0.0.1:6042R127.0.0.1:6042/sdb4_"" with 1.0 weight got id 3
Reassigned 1024 (100.00%) partitions. Balance is now 0.00.
```

Now we can start various swift services:

```
vagrant@precise64:~$ startmain
WARNING: Unable to increase file descriptor limit.  Running as non-root?
Starting proxy-server...(/etc/swift/proxy-server.conf)
Starting container-server...(/etc/swift/container-server/1.conf)
Starting container-server...(/etc/swift/container-server/2.conf)
Starting container-server...(/etc/swift/container-server/3.conf)
Starting container-server...(/etc/swift/container-server/4.conf)
Starting account-server...(/etc/swift/account-server/1.conf)
Starting account-server...(/etc/swift/account-server/2.conf)
Starting account-server...(/etc/swift/account-server/3.conf)
Starting account-server...(/etc/swift/account-server/4.conf)
Starting object-server...(/etc/swift/object-server/1.conf)
Starting object-server...(/etc/swift/object-server/2.conf)
Starting object-server...(/etc/swift/object-server/3.conf)
Starting object-server...(/etc/swift/object-server/4.conf)
```

At this point it's best to look at the official [Swift all-in-one](http://docs.openstack.org/developer/swift/development_saio.html) documentation as to the next steps, or if you are a Swift developer you probably know what you need to do next. :)

## Puppet

### shell inline

In the Vagrant file the puppet.sh script is run, and also a couple of inline shell commands, one of which installs [vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo) which is a dependency of puppet-saio.

### puppet.sh

The puppet.sh script will install puppet 3+, though puppet does come with Vagrant, just an older version. I would expect that the Vagrant puppet would work fine though.

## Development environment

* Puppet 3.3.2
* OSX 10.8.2
* Virtualbox 4.2.6
* Vagrant 1.3.5
* Ubuntu 12.04 for the vm

## Todo

See the [todo](TODO.md) file.