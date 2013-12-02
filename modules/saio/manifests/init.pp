class saio {
	
	#
	# Install OpenStack Swift exactly the way the Swift All In One document describes
	# See: http://docs.openstack.org/developer/swift/development_saio.html
	#

	package { ['curl',
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
			   'python-mock' ]:

		ensure => installed,
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
    	command => '/sbin/mkfs.xfs /srv/swift-disk',
    	require => Exec['create sparse disk'],
    	refreshonly => true,
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
        require => File['/mnt/sdb1'],
    }

    # 
    # Create server mount points 
    # 

    $sdb1_dirs = [ "/mnt/sdb1/1", "/mnt/sdb1/2", "/mnt/sdb1/3", "/mnt/sdb1/4" ]

    file { $sdb1_dirs:
    	ensure => directory,
    	owner => vagrant,
    	group => vagrant,
    	mode => 644,
    	require => Mount['/mnt/sdb1'],
    }
}