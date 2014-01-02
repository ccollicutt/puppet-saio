#SAIO

####Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with SAIO](#setup)
    * [What SAIO affects](#what-saio-affects)
    * [Beginning with SAIO](#beginning-with-saio)
3. [After Puppet has run](#post-puppet)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

##Overview

This module will install [OpenStack Swift All-in-one](http://docs.openstack.org/developer/swift/development_saio.html) (SAIO) on a single server. Currently the instructions for Swift-all-in-one list commands and files to copy and paste. This module automates running those commands and copying the files to install Swift-all-in-one quickly using Puppet.

Ideally it would be used with [Vagrant](http://vagrantup.com) as a place to develop and test OpenStack Swift, but without requiring multiple instances of Ubuntu 12.04 on which to run it. Instead all services run on one instance.

##Setup

###What SAIO affects

This module will install many packages and services, so we are expecting that it would be used as part of a local virtualized development environment which can be built and destroyed many times over, ala [Vagrant](http://vagrantup.com).

Some of the things it affects:

* rsyncd
* rsyslog
* Creates a sparse file
* Adds a loopback device 
* Installs all the packages needed for OpenStack Swift 
* Downloads, builds, and installs python-swiftclient and swift
* Installs several helper bash scripts to start and use Swift
* All the services required for OpenStack Swift will be running on this one server
 
###Beginning with SAIO	

First, this module uses the [Vcsrepo module](https://forge.puppetlabs.com/puppetlabs/vcsrepo) and stdlib so those need to be installed.

```
puppet module install puppetlabs/vcsrepo
puppet module install puppetlabs/stdlib
```

We can now use the module by initiating use of the saio class and optionally provide parameters for swiftuser and swiftgroup:

```
node 'precise64' {
	class { 'saio':
	}
}
```

There are a few optional parameters. Below are their defaults:

```
$swiftuser='vagrant', 
$swiftgroup='vagrant',
$swiftclient_repo='https://github.com/openstack/python-swiftclient.git',
$swift_repo='https://github.com/openstack/swift.git',
$package_cache_srv=undef,
$run_unittests=true,
```

The package_cache_srv is a apt-cache-ng server's IP address. Usually I have a local vm running apt-cache-ng which  projects like SAIO use to grab packages from instead of having to download them from the Internet every single time.

### Post puppet

Once the puppet install has run its course, you can now use the bash scripts to generate the ring files and (hopefully) startup Swift.

```
vagrant@precise64:/etc/puppet$ remakerings 
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

Now all the Swift servers can be started:

```
vagrant@precise64:/etc/puppet$ startmain 
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

Next, upload a file:

```
vagrant@precise64:~$ echo "swift is cool" > swift.txt
vagrant@precise64:~$ swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing upload swifty swift.txt 
swift.txt
vagrant@precise64:~$ swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing list swifty       
swift.txt
```

##Limitations

* Only works on Ubuntu 12.04

##Development

The github repository for this module can be found [here](http://github.com/curtisgithub/puppet-saio) so feel free to send a pull request. :)

