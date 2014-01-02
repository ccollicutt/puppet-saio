class saio::sparse_disk inherits saio {

  #
  # Create a sparse disk, mount it, and create some directories underneath it
  #

  exec { 'create sparse disk':
    command => '/usr/bin/truncate -s 1GB /srv/swift-disk',
    creates => '/srv/swift-disk',
  }

  exec { 'make xfs file system on sparse disk':
    command     => '/sbin/mkfs.xfs /srv/swift-disk',
    refreshonly => true,
    subscribe   => Exec['create sparse disk']
  }

  file { '/mnt/sdb1':
    ensure => directory,
  }

  $mount_points = [ '/mnt/sdb1/1', '/mnt/sdb1/2', '/mnt/sdb1/3', '/mnt/sdb1/4' ]

  mount { '/mnt/sdb1':
    ensure  => 'mounted',
    device  => '/srv/swift-disk',
    fstype  => 'xfs',
    options => 'loop,noatime,nodiratime,nobarrier,logbufs=8',
    atboot  => true,
    require => [
                Exec['make xfs file system on sparse disk'],
                File['/mnt/sdb1']
               ]
  }

  file { $mount_points:
  	ensure  => directory,
  	require => Mount['/mnt/sdb1']
  }

}