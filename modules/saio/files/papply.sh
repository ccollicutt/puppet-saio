#!/bin/bash

sudo puppet apply /vagrant/manifests/site.pp --modulepath=/vagrant/modules/:/etc/puppet/modules $*