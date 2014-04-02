class saio::build inherits saio {

  #
  # Download and build python-swiftclient and swift source
  #

  package { 'git':
    ensure => installed,
  }

  file {'/usr/local/src/swift':
    ensure => directory,
    mode   => '0777',
  }

  vcsrepo { '/usr/local/src/swift/python-swiftclient':
    ensure   => latest,
    owner    => $swiftuser,
    group    => $swiftuser,
    provider => git,
    require  => [
                  Package['git'],
                  File['/usr/local/src/swift']
                ],
    source   => $swiftclient_repo,
    revision => 'master',
  }

  vcsrepo { '/usr/local/src/swift/swift':
    ensure   => latest,
    owner    => $swiftuser,
    group    => $swiftuser,
    provider => git,
    require  => [
                  Package['git'],
                  File['/usr/local/src/swift']
                ],
    source   => $swift_repo,
    revision => 'master',
  }

  #
  # Build python-swiftclient and swift
  #

  exec {'build python-swiftclient':
    cwd     => '/usr/local/src/swift/python-swiftclient',
    command => '/usr/bin/python setup.py develop',
    creates => '/usr/local/bin/swift',
    require => [
                  Vcsrepo['/usr/local/src/swift/python-swiftclient'], 
                  Exec['install required python-swiftclient pip modules']
                ]
  }

  exec {'build swift':
    cwd     => '/usr/local/src/swift/swift',
    command => '/usr/bin/python setup.py develop',
    creates => '/usr/local/bin/swift-ring-builder',
    require => [
                  Vcsrepo['/usr/local/src/swift/swift'], 
                  Exec['install required swift pip modules']
                ]
  }

  #
  # pip requirements
  # - maybe there is a puppet resource for pip?
  #

  exec {'install required swift pip modules':
    cwd     => '/usr/local/src/swift/swift',
    command => '/usr/bin/pip install -r test-requirements.txt',
    require => [
                 Package['python-pip'],
                 Exec['apt-get update'],
                 Vcsrepo['/usr/local/src/swift/swift']
                ]
  }

  exec {'install required python-swiftclient pip modules':
    cwd     => '/usr/local/src/swift/python-swiftclient',
    command => '/usr/bin/pip install -r test-requirements.txt',
    require => [
                 Package['python-pip'],
                 Exec['apt-get update'],
                 Vcsrepo['/usr/local/src/swift/python-swiftclient']
                ]
  }

}