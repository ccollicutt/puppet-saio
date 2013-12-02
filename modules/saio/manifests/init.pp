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
    # Create server mount points which are links to the /mnt/sdb1/[1,2,3,4] directories
    # - Note that we have to do a bit of trickery here with puppet and a defined resource.
    #

    define create_srv_mnt_points {
  		file { "/srv/${title}":
      		ensure => link,
     		target => "/mnt/sdb1/${title}",
    		require => File["/mnt/sdb1"]
  		}
	}

	$srv_mnt_points = ['1','2','3','4']

	create_srv_mnt_points { $srv_mnt_points: }

	# 
	# More directories...
	# - Note that the parent directories have to exist too otherwise puppet will fail
	#

	$server_dirs = ['/etc/swift', 
				   '/etc/swift/object-server', 
				   '/etc/swift/container-server', 
				   '/etc/swift/account-server ', 
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
		ensure => directory,
		owner => vagrant,
		group => vagrant,
		mode => 644,
		require => [ File['/srv/1'],
				     File['/srv/2'],
				     File['/srv/3'],
				     File['/srv/4'],
				    ]
	}


	#
	# Note that this is probably not the best way to do this
	# 

	file { '/etc/rc.local':
		source => 'puppet:///modules/saio/rc.local',
		owner => root,
		group => root,
		mode => 755
	}

	# 
	# Configure rsyncd
	#

	file { '/etc/rsyncd.conf':
		source => 'puppet:///modules/saio/rsyncd.conf',
		owner => root,
		group => root,
		mode => 644,
		notify => Service['rsync']
	}

	# Configure rsyncd to start 
	file { '/etc/default/rsync':
		source => 'puppet:///modules/saio/default_rsync',
		owner => root,
		group => root,
		mode => 644,
		notify => Service['rsync']
	}

    service { 'rsync':
    	ensure => running,
    	require => [ File['/etc/rsyncd.conf'], 
    				 File['/etc/default/rsync'], 
    				 Package['rsync']
    			    ],

    }

    #
    # Memcached
    #

    service { 'memcached':
    	ensure => 'running'
    }

    #
    # logging
    #

    file { '/etc/rsyslog.d/10-swift.conf':
    	source => 'puppet:///modules/saio/10-swift.conf',
    	notify => Service['rsyslog'],
    	group => root,
    	owner => root,
    	mode => 644
    }

    file { '/etc/rsyslog.conf':
    	source => 'puppet:///modules/saio/rsyslog.conf',
    	notify => Service['rsyslog'],
		group => root,
    	owner => root,
    	mode => 644
    }

    service { 'rsyslog':
    	ensure => 'running',
    	require => File['/etc/rsyslog.d/10-swift.conf']
    }


}