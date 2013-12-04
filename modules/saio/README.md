#SAIO

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [Modulename]](#setup)
    * [What [Modulename] affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [Modulename]](#beginning-with-[Modulename])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module will install OpenStack Swift All-in-one (SAIO) on a single server. Currently the instuctions for Swift-all-in-one list commands and files to copy and paste. This module automates running those commands and copying the files to install Swift-all-in-one quickly.

Ideally it would be used with [Vagrant](http://vagrantup.com) as a place to develop and test OpenStack Swift, but without requiring multiple instances of Ubuntu 12.04 on which to run Swift. Instead all services run on one instance.     

##Module Description

This module installs all the configuration files and services needed to run OpenStack Swift on a single server, also known as [OpenStack Swift All-in-one](http://docs.openstack.org/developer/swift/development_saio.html).

##Setup

###What SAIO affects

This module will install many packages and services, so we are expecting that it would be used as part of a virtualized environment which can be built and destroyed many times over, ala [Vagrant](http://vagrantup.com).

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

First, this module uses the [Vcsrepo module](https://forge.puppetlabs.com/puppetlabs/vcsrepo), so that needs to be installed.

```
puppet module install puppetlabs/vcsrepo
```

Once Vcsrepo is installed, we can now use the module by initiating use of the saio class and optionally provide parameters for swiftuser and swiftgroup:

```
node 'precise64' {
	class { 'saio':
	}
}
```
Note that is no swiftuser or swiftgroup is provided the vagrant user and group will be used.

Optionally add a user and group (which must exist already):

```
node 'precise64' {
	class { 'saio':
		swiftuser => curtis,
		swiftgroup => curtis
	}
}
```

##Usage

##Limitations

* Ubuntu 12.04

##Development

There are no groundrules for contributing other than using github pull requests.

The github repository for this module can be found [here](http://github.com/curtisgithub/puppet-saio)

