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
  $swiftuser           = $saio::params::swiftuser,
  $swiftgroup          = $saio::params::swiftgroup,
  $swiftclient_repo    = $saio::params::swiftclient_repo,
  $swift_repo          = $saio::params::swift_repo,
  $package_cache_srv   = $saio::params::package_cache_srv,
  $run_unittests       = $saio::params::run_unittests,
  $start_swift         = $saio::params::start_swift
  ) inherits saio::params {

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
  class { '::saio::test': } ->
  class { '::saio::config': } ->
  class { '::saio::service': } ->
  class { '::saio::start_swift': } ->
  anchor { 'saio::end': }

}