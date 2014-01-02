class saio::install inherits saio {

  # If a package_cache_srv, ie. apt-cache-ng server IP is supplied,
  # add then install a proxy config file for apt.
  if $package_cache_srv {
    file { '/etc/apt/apt.conf.d/01proxy':
      content => template('saio/01proxy.erb'),
      owner   => root,
      group   => root,
      mode    => '0644'
    }

  }

  # only run if needed
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || \
    /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | \
    /bin/grep . > /dev/null'",
  }

  # now start installing as per instructions...
  package { $saio::params::packages:
    ensure  => installed,
    require => Exec['apt-get update']
  }

}