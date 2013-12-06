  define saio::create_srv_mnt_points() {
    file { "/mnt/sdb1/${title}":
      ensure => directory,
    }
    file { "/srv/${title}":
      ensure  => link,
      target  => "/mnt/sdb1/${title}",
      require => File["/mnt/sdb1/${title}"]
    }
  }