node 'precise64' {
	class { 'saio':
		package_cache_srv => '192.168.100.20',
		run_unittests     => 'false',
	}
}
