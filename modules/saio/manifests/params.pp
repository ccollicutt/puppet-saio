class saio::params {
	
  $swiftuser         = 'vagrant'
  $swiftgroup        = 'vagrant'
  $swiftclient_repo  = 'https://github.com/openstack/python-swiftclient.git'
  $swift_repo        = 'https://github.com/openstack/swift.git'
  $package_cache_srv = undef
  $run_unittests     = false
  $start_swift       = true

  $server_mount_points = ['1','2','3','4']
  
  $packages = [
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
       		  ]

  $server_directories = [
				           '/etc/swift',
				           '/etc/swift/object-server',
				           '/etc/swift/container-server',
				           '/etc/swift/account-server',
				           '/srv',
				           '/srv/1/node',
				           '/srv/2/node',
				           '/srv/3/node',
				           '/srv/4/node',
				           '/srv/1/node/sdb1',
				           '/srv/2/node/sdb2',
				           '/srv/3/node/sdb3',
				           '/srv/4/node/sdb4',
				           '/var/run/swift',
				           '/var/cache/swift',
				           '/var/cache/swift2',
				           '/var/cache/swift3',
				           '/var/cache/swift4'
         				 ]

 $storage_servers = ['1','2','3','4']

 $swift_source_directory = '/usr/local/src/swift/swift'

}
