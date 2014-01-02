class saio::service inherits saio {

  service { 'rsync':
    ensure    => running,
    subscribe => File['/etc/rsyncd.conf'],
    require   => [
                   File['/etc/rsyncd.conf'],
                   File['/etc/default/rsync'],
                   Package['rsync']
                  ],
  }

  service { 'memcached':
    ensure  => 'running',
  }

  service { 'rsyslog':
    ensure  => 'running',
    require => File['/etc/rsyslog.d/10-swift.conf']
  }

}