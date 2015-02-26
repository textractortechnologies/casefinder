node casefinder {
  include rvm
  include webserver
  include webserver::passenger
  include epel
  include deploy
  include vagrant


  service { 'firewalld':
    status => stopped,
  }

  Yumrepo <| |> -> Package <| |>

  yumrepo { 'local_rpms':
    ensure   => present,
    baseurl  => 'file:///vagrant/rpms',
    gpgcheck => '0',
  }

  user { 'deploy':
    ensure     => present,
    managehome => true,
    uid        => '599',
    groups     => [ 'apache','deploy',],
    require    => Package['httpd']
  }

  ssh_authorized_key { 'mgurley':
    user => 'deploy',
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCvCrsKN2WFXlyDQQEPGpdlXLnGZibs52a6bX3R2dt5kz1Ld5+x9eBZHf0Y97PoVdaDcQIoDL1eBNdSL7DH95Rwb0IUAMQQvu9n399tlrdded2HPxKGsGwP6mZeZ98dBRQizrF7+p/tQQvg2v3hkRrxl6bI/36m+Bv0urCGckYKLJ7Y90vmEzyKpDz1L09LcEoGv4yTTq9JRV3U/WeZfVyfi8oSyq1ZuKVeUP8+pKkl1sZL7XMbnVE9dMB0HGaSBpc1Okhor/XgpclBB/l4dG8kC37Qlm2x7et/hq3usvofA8tyW7xk5Lhz/pIZXkJkGcyhdJlMbrpw0HWO+tx2Tei/',
  }

  group { 'deploy':
    ensure => present,
    gid    => '599',
  }

  file { '/etc/httpd/conf.d/casefinder.conf':
    ensure  => file,
    owner   => 'deploy',
    group   => 'root',
    mode    => '655',
    content => template('deploy/vhost.conf.erb'),
    notify  => Service['httpd'],
  }

  rvm_system_ruby {
    'ruby-2.2':
      ensure      => 'present',
      default_use => false;
  }

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
    postgis_version     => '2.1',
    }->

    class { 'postgresql::server':
      ip_mask_deny_postgres_user => '0.0.0.0/32',
      ip_mask_allow_all_users    => '0.0.0.0/0',
      listen_addresses           => '*',
      ipv4acls                   => ['local all all md5'],
      #development only
      postgres_password          => 'ghewUkEck3',
    } ->

    class { 'postgresql_backup':
      backup_path => '/var/lib/pgsql/9.4/backups',
    }

    postgresql::server::pg_hba_rule { 'allow localhost access by casefinder':
      description => "allow localhost access by casefinder",
      type => 'host',
      database => 'casefinder',
      user => 'casefinder',
      address => '127.0.0.1/32',
      auth_method => 'md5',
    }

    postgresql::server::db { 'casefinder':
      user     => 'casefinder_user',
      password => 'DabcosyupKoacDytmilejRumHypHeOp6',
    }

}
