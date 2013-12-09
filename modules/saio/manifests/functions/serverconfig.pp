define saio::functions::serverconfig {
  file { "/etc/swift/object-server/${title}.conf":
    content => template("saio/object-server-${title}.conf.erb"),
    owner   => $swiftuser,
    group   => $swiftgroup,
    mode    => 644,
  }
  file { "/etc/swift/account-server/${title}.conf":
    content => template("saio/account-server-${title}.conf.erb"),
    owner   => $swiftuser,
    group   => $swiftgroup,
    mode    => 644,
  }
  file { "/etc/swift/container-server/${title}.conf":
    content => template("saio/container-server-${title}.conf.erb"),
    owner   => $swiftuser,
    group   => $swiftgroup,
    mode    => 644,         
  } 
}