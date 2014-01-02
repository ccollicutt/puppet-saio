define saio::functions::mountpoints() {
  file { "/srv/${title}":
    ensure  => link,
    target  => "/mnt/sdb1/${title}",
  }
}