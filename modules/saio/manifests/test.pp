class saio::test inherits saio {

  #
  # Only run if run_unittests is set
  #

  if $run_unittests == 'true' {

    #
    # Setup test environment
    #

    # Going to put this into /etc/profile.d instead of trying to add
    # it to the user's .bashrc
    file { '/etc/profile.d/swift_test.sh':
      source => 'puppet:///modules/saio/swift_test.sh',
      mode   => '0644',
      owner  => $swiftuser,
      group  => $swiftgroup,
    }

    $swift_dir = $saio::params::swift_source_directory

    # Just make this a link instead of copying
    file { '/etc/swift/test.conf':
      ensure => link,
      target => "${swift_dir}/test/sample.conf"
    }

    # Run the unittests once
    # - note setting the environment variable just in case,
    #   is also in swift_test.sh
    exec { "${swift_dir}/.unittests":
      environment => 'SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf',
      command     => "${swift_dir}/.unittests && touch ${swift_dir}/unittests.run",
      creates     => "${swift_dir}/unittests.run",
      require     => [
                       Exec['install required swift pip modules'],
                       File['/etc/swift/test.conf'],
                       Vcsrepo['/usr/local/src/swift/swift']
                     ]
    }
  }

}