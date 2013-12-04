class saio ( 
  $swiftuser='vagrant', 
  $swiftgroup='vagrant',
  $swiftclient_repo='https://github.com/openstack/python-swiftclient.git',
  $swift_repo='https://github.com/openstack/swift.git'
  ) {
  
  #
  # Install OpenStack Swift exactly the way the Swift All In One document describes
  # See: http://docs.openstack.org/developer/swift/development_saio.html
  #

  # only run if needed
  exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
  }

  # now start installing as per instructions...
  package { [
         'curl',
         'gcc', 
         'memcached',
         'rsync',
         'sqlite3',
         'xfsprogs',
         'git-core',
         'libffi-dev',
         'python-setuptools',
         'python-coverage',
         'python-dev',
         'python-nose',
         'python-simplejson',
         'python-xattr', 
         'python-eventlet',
         'python-greenlet', 
         'python-pastedeploy', 
         'python-netifaces', 
         'python-pip',
         'python-dnspython',
         'python-mock' 
        ]:

    ensure => installed,
    require => Exec['apt-get update']
  }

  #
  # Create a sparse disk to mount
  #

  file { '/srv':
    ensure => directory,
  }

  exec { 'create sparse disk':
    command => '/usr/bin/truncate -s 1GB /srv/swift-disk',
    require => File['/srv'],
    creates => '/srv/swift-disk',
  }

  exec { 'make xfs file system on sparse disk':
  command     => '/sbin/mkfs.xfs /srv/swift-disk',
    refreshonly => true,
    subscribe   => Exec['create sparse disk']
  }

  #
  # Now mount the sparse disk
  #

  file { '/mnt/sdb1':
    ensure => directory,
  }

  mount { '/mnt/sdb1':
    device  => "/srv/swift-disk",
    fstype  => "xfs",
    ensure  => "mounted",
    options => "loop,noatime,nodiratime,nobarrier,logbufs=8",
    atboot  => "true",
    require => [ 
                Exec['make xfs file system on sparse disk'],
                File['/mnt/sdb1']
               ]
  }

  # 
  # Create server mount points which are links to the /mnt/sdb1/[1,2,3,4] directories
  #

  define create_srv_mnt_points() {
    file { "/mnt/sdb1/${title}":
      ensure => directory,
    }
    file { "/srv/${title}":
      ensure  => link,
      target  => "/mnt/sdb1/${title}",
      require => File["/mnt/sdb1/${title}"]
    }
  }

  $srv_mnt_points = ['1','2','3','4']

  create_srv_mnt_points { $srv_mnt_points: 
    require => Mount['/mnt/sdb1'],
  }

  # 
  # More directories...
  # - Note that the parent directories have to exist too otherwise puppet will fail
  #

  $server_dirs = [
           '/etc/swift', 
           '/etc/swift/object-server', 
           '/etc/swift/container-server', 
           '/etc/swift/account-server', 
           '/srv/1/node',
           '/srv/2/node',
           '/srv/3/node',
           '/srv/4/node',
           '/srv/1/node/sdb1', 
           '/srv/2/node/sdb2', 
           '/srv/3/node/sdb3', 
           '/srv/4/node/sdb4', 
           '/var/run/swift'
           ]

  file { $server_dirs:
    ensure  => directory,
    owner   => $swiftuser,
    group   => $swiftuser,
    mode    => 644,
    require => [ 
                 File['/srv/1'],
                 File['/srv/2'],
                 File['/srv/3'],
                 File['/srv/4'],
               ]
  }


  #
  # rc.local
  # - note that this is probably not the best way to do this
  # 

  file { '/etc/rc.local':
    content => template('saio/rc.local.erb'),
    owner   => root,
    group   => root,
    mode    => 755
  }

  # 
  # Configure rsyncd
  #

  file { '/etc/rsyncd.conf':
    content => template('saio/rsyncd.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 644,
  }

  file { '/etc/default/rsync':
    source => 'puppet:///modules/saio/default_rsync',
    owner  => root,
    group  => root,
    mode   => 644,
  }

  service { 'rsync':
    ensure    => running,
    subscribe => File['/etc/rsyncd.conf'],
    require   => [ 
                   File['/etc/rsyncd.conf'], 
                   File['/etc/default/rsync'], 
                   Package['rsync']
                  ],
  }

  #
  # Memcached
  #

  service { 'memcached':
    ensure  => 'running',
    require => [ Package['memcached'], Exec['apt-get update'] ]
  }

  #
  # Setup logging and rsyslogd
  #

  file { '/etc/rsyslog.d/10-swift.conf':
    source => 'puppet:///modules/saio/10-swift.conf',
    notify => Service['rsyslog'],
    group  => $swiftuser,
    owner  => $swiftgroup,
    mode   => 644
  }

  file { '/etc/rsyslog.conf':
    source => 'puppet:///modules/saio/rsyslog.conf',
    notify => Service['rsyslog'],
    group  => root,
    owner  => root,
    mode   => 644
  }

  service { 'rsyslog':
    ensure  => 'running',
    require => File['/etc/rsyslog.d/10-swift.conf']
  }

  file { '/var/log/swift':
    ensure => directory,
    owner  => syslog,
    group  => adm,
    mode   => 755,
    notify => Service['rsyslog']
  }

  file { '/var/log/swift/hourly':
    ensure => directory,
    owner  => syslog,
    group  => adm,
    mode   => 755,
    notify => Service['rsyslog']
  }

  #
  # Download and build python-swiftclient and swift source
  # 

  package { 'git':
    ensure => installed,
  }

  file {'/usr/local/src/swift':
    ensure => directory,
    mode   => 777
  }
    
  vcsrepo { "/usr/local/src/swift/python-swiftclient":
    ensure   => latest,
    owner    => $swiftuser,
    group    => $swiftuser,
    provider => git,
    require  => [ 
                  Package["git"],
                  File['/usr/local/src/swift'] 
                ],
    source   => $swiftclient_repo,
    revision => 'master',
  }

  vcsrepo { "/usr/local/src/swift/swift":
    ensure   => latest,
    owner    => $swiftuser,
    group    => $swiftuser,
    provider => git,
    require  => [ 
                  Package["git"],
                  File['/usr/local/src/swift']  
                ],
    source   => $swift_repo,
    revision => 'master',
  }

  #
  # Build python-swiftclient and swift
  # 

  exec {'build python-swiftclient':
    cwd => '/usr/local/src/swift/python-swiftclient',
    command => '/usr/bin/python setup.py develop',
    creates => '/usr/local/bin/swift',
    require => Vcsrepo['/usr/local/src/swift/python-swiftclient'],
  }

  exec {'build swift':
    cwd => '/usr/local/src/swift/swift',
    command => '/usr/bin/python setup.py develop',
    creates => '/usr/local/bin/swift-ring-builder',
    require => Vcsrepo['/usr/local/src/swift/swift']
  }

  #
  # pip requirements
  # - maybe there is a puppet resource for pip?
  #

  exec {'install required pip modules':
    cwd => '/usr/local/src/swift/swift',
    command => '/usr/bin/pip install -r test-requirements.txt',
    require => [ 
                 Package['python-pip'], 
                 Exec['apt-get update'], 
                 Vcsrepo['/usr/local/src/swift/swift']
                ]
  }

  #
  # Swift server configuration files
  # 

  # XXX fix the user in this file XXX
  file { '/etc/swift/proxy-server.conf':
    content => template('saio/proxy-server.conf.erb'),
    notify  => Service['rsyslog'],
    group   => $swiftuser,
    owner   => $swiftgroup,
    mode    => 644
  }

  # XXX fix the hashes to be variables XXX
  file { '/etc/swift/swift.conf':
    source => 'puppet:///modules/saio/swift.conf',
    notify => Service['rsyslog'],
    group  => $swiftuser,
    owner  => $swiftgroup,
    mode   => 644
  }

  define create_srv_cfg_files {
    file { "/etc/swift/object-server/${title}.conf":
      content => template("saio/object-server-${title}.conf.erb"),
      owner   => $swiftuser,
      group   => $swiftgroup,
      mode    => 644,
    }
    file { "/etc/swift/account-server/${title}.conf":
      content => template("saio/account-server-${title}.conf.erb"),
      owner   => $swiftuser,
      group   => $swiftgroup,
      mode    => 644,
    }
    file { "/etc/swift/container-server/${title}.conf":
      content => template("saio/container-server-${title}.conf.erb"),
      owner   => $swiftuser,
      group   => $swiftgroup,
      mode    => 644,         
    } 
  }

  $swift_srvs = ['1','2','3','4']

  create_srv_cfg_files { $swift_srvs: }

  #
  # Helpful bash scripts
  #

  # XXX Could be reduced XXX
  file { '/usr/local/bin/resetswift':
    content => template('saio/resetswift.sh.erb'),
    mode    => 755,
    owner   => $swiftuser,
    group   => $swiftgroup,
  }

  file { '/usr/local/bin/remakerings':
    source => 'puppet:///modules/saio/remakerings.sh',
    mode   => 755,
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/startmain':
    source => 'puppet:///modules/saio/startmain.sh',
    mode   => 755,
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/startrest':
    source => 'puppet:///modules/saio/startrest.sh',
    mode   => 755,
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/saio/papply.sh',
    mode   => 755,
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  #
  # Setup test environment
  # 

  # Going to put this into /etc/profile.d instead of trying to add it to the user's .bashrc
  file { '/etc/profile.d/swift_test.sh':
    source => 'puppet:///modules/saio/swift_test.sh',
    mode   => 644,
    owner  => $swiftuser,
    group  => $swiftgroup,
  }

  $swift_dir = '/usr/local/src/swift/swift'

  # Just make this a link instead of copying
  file { '/etc/swift/test.conf':
    ensure => link,
    target => "${swift_dir}/test/sample.conf"
  }

  # Run the unittests once
  # - note setting the environment variable just in case, is also in swift_test.sh
  exec { "${swift_dir}/.unittests":
    environment => "SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf",
    command => "${swift_dir}/.unittests && touch ${swift_dir}/unittests.run",
    creates => "${swift_dir}/unittests.run",
    require => [
                 Exec['install required pip modules'],
                 File['/etc/swift/test.conf'],
                 Vcsrepo['/usr/local/src/swift/swift']
                ]
  }
}