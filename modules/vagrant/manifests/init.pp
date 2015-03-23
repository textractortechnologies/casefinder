class vagrant {

  $vagrant_packages = ['nss-mdns', 'avahi']

  package { $vagrant_packages: ensure => installed }

  service { 'messagebus':
    ensure  => running,
    enable  => true,
    require => Package[$vagrant_packages],
  }

  service { 'avahi-daemon':
    ensure  => running,
    enable  => true,
    require => Service['messagebus'],
  }

  #  group { 'sudoers':
  #    ensure => 'present',
  #    gid    => '200',
  #  }

  host { 'localhost':
    ensure       => present,
    comment      => 'ipv4 localhost',
    ip           => '127.0.0.1',
    host_aliases => [ 'localhost.localdomain', 'localhost4', 'localhost4.localdomain4'],
  }

}
