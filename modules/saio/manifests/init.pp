# == Class: saio
#
# Deploy OpenStack Swift All-in-one
#
# === Parameters
#
# Document parameters here.
#
# [*swiftuser*]
#   Set the user the swift files and processes are going to be owned by.
#
# [*swiftgroup*]
#   Set the group the swift files and processes are going to be owned by.
#
# [*swiftclient_repo*]
#   The git repository the swiftclient code resides in.
#
# [*swift_repo*]
#   The git repository the swift code resides in.
#
# [*package_cache_srv*]
#   The IP address of a local apt-cache-ng server to use to download
#   apt packages from.
#
# === Variables
#
# None
#
# === Examples
#
#  class { 'saio':
#  }
#
# === Authors
#
# Curtis <curtis@serverascode.com>
#
# === Copyright
#
# Copyright 2013
#
class saio (
  $swiftuser='vagrant',
  $swiftgroup='vagrant',
  $swiftclient_repo='https://github.com/openstack/python-swiftclient.git',
  $swift_repo='https://github.com/openstack/swift.git',
  $package_cache_srv=undef,
  $run_unittests=true,
  ) {

  #
  # Install OpenStack Swift exactly the way Swift All In One describes
  # See: http://docs.openstack.org/developer/swift/development_saio.html
  #
  # I've tried to keep everything as similar as possible to that document.
  # 

  include saio::params

  # Anchor this as per #8040 
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues

  anchor { 'saio::begin': } ->
  class { '::saio::install': } ->
  class { '::saio::sparse_disk': } ->
  class { '::saio::directories': } ->
  class { '::saio::files': } ->
  class { '::saio::build': } ->
  class { '::saio::config': } ~>
  class { '::saio::service': }

  if $run_unittests == 'true' {
    notice("running unittests")
    class { '::saio::test': }
  }
  else {
    notice("NOT running unittests")
  }

  anchor { 'saio::end': }

}