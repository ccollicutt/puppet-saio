class saio::start_swift inherits saio {

  #
  # Only run if start_swift is set
  #

  if $start_swift == 'true' {

	  exec { "remakerings":
	    command => "/usr/local/bin/remakerings",
	    creates => "/etc/swift/object.ring.gz",
	  }

	  #
	  # XXX - this file part needs to be better organized, shouldn't be three calls
	  #       also there are other files in that directory that need the right permissions
	  #

	  File {
	  	owner   => $swiftuser,
	  	group   => $swiftgroup,
	  	mode    => '0640',
	  }

	  file {'/etc/swift/object.ring.gz':
	  	require => Exec['remakerings']
	  }

	  file {'/etc/swift/account.ring.gz':
	  	require => Exec['remakerings']
	  }

	  file {'/etc/swift/container.ring.gz':
	  	require => Exec['remakerings']
	  }

	  #
	  # End file
	  #

	  exec {'startmain':
	  	command  => '/usr/local/bin/startmain',
	  	require  => [
	  				  File['/etc/swift/object.ring.gz'],
	  				  File['/etc/swift/account.ring.gz'],
	  				  File['/etc/swift/container.ring.gz'],
	  			    ]
	  }

	  exec {'startrest':
	  	command  => '/usr/local/bin/startrest',
	  	require  => Exec['startmain']
	  }
  }
}