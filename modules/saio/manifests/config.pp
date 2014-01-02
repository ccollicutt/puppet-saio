class saio::config inherits saio {

  #
  # Swift server configuration files
  #

  # XXX fix the user in this file XXX
  file { '/etc/swift/proxy-server.conf':
    content => template('saio/proxy-server.conf.erb'),
    notify  => Service['rsyslog'],
    group   => $swiftuser,
    owner   => $swiftgroup,
    mode    => '0644',
  }

  # XXX fix the hashes to be variables XXX
  file { '/etc/swift/swift.conf':
    source => 'puppet:///modules/saio/swift.conf',
    notify => Service['rsyslog'],
    group  => $swiftuser,
    owner  => $swiftgroup,
    mode   => '0644',
  }

  saio::functions::serverconfig { $saio::params::storage_servers: }

  #
  # rc.local
  # - note that this is probably not the best way to do this
  #

  file { '/etc/rc.local':
    content => template('saio/rc.local.erb'),
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  #
  # Configure rsyncd
  #

  file { '/etc/rsyncd.conf':
    content => template('saio/rsyncd.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  file { '/etc/default/rsync':
    source => 'puppet:///modules/saio/default_rsync',
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  #
  # rsyslog
  #

  file { '/etc/rsyslog.d/10-swift.conf':
    source => 'puppet:///modules/saio/10-swift.conf',
    notify => Service['rsyslog'],
    group  => $swiftuser,
    owner  => $swiftgroup,
    mode   => '0644',
  }

  file { '/etc/rsyslog.conf':
    source => 'puppet:///modules/saio/rsyslog.conf',
    notify => Service['rsyslog'],
    group  => root,
    owner  => root,
    mode   => '0644',
  }

}