class saio::directories inherits saio {

  file { '/var/log/swift':
    ensure => directory,
    owner  => syslog,
    group  => adm,
    mode   => '0755',
    notify => Service['rsyslog']
  }

  file { '/var/log/swift/hourly':
    ensure => directory,
    owner  => syslog,
    group  => adm,
    mode   => '0755',
    notify => Service['rsyslog']
  }

  #
  # More directories...
  # - Note that the parent directories have to exist too
  #   otherwise puppet will fail
  #

  file { $saio::params::server_directories:
    ensure  => directory,
    owner   => $swiftuser,
    group   => $swiftuser,
    mode    => '0644',
  }

  #
  # Sparse disk directory
  #

  file { "$saio::params::server_mount_points":
    path   => "/mnt/sdb1/${name}",
    ensure => directory,
  }

  saio::functions::mountpoints { $saio::params::server_mount_points:
  }


}