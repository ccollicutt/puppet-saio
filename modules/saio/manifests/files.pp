  class saio::files inherits saio {

  #
  # Helpful bash scripts
  #

  # XXX Could be reduced XXX
  file { '/usr/local/bin/resetswift':
    content => template('saio/resetswift.sh.erb'),
    mode    => '0755',
    owner   => $swiftuser,
    group   => $swiftgroup,
  }

  file { '/usr/local/bin/remakerings':
    source => 'puppet:///modules/saio/remakerings.sh',
    mode   => '0755',
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/startmain':
    source => 'puppet:///modules/saio/startmain.sh',
    mode   => '0755',
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/startrest':
    source => 'puppet:///modules/saio/startrest.sh',
    mode   => '0755',
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/saio/papply.sh',
    mode   => '0755',
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

}