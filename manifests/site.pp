node casefinder {
  include rvm
  include webserver
  include webserver::passenger
  include epel
  include deploy
  include vagrant


  package { 'unzip':
    ensure => installed,
  }

  package { 'java-1.7.0-openjdk':
    ensure => absent,
  }

  package { 'java-1.7.0-openjdk-devel':
    ensure => absent,
  }

  package { 'java-1.7.0-openjdk-headless':
    ensure => absent,
  }

  package { 'java-1.8.0-openjdk-headless':
    ensure => present,
  }

  package { 'java-1.8.0-openjdk-devel':
    ensure => present,
  }

  package { 'nodejs':
    ensure => installed,
  }


  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  Yumrepo <| |> -> Package <| |>

  yumrepo { 'local_rpms':
    ensure   => present,
    baseurl  => 'file:///vagrant/rpms',
    gpgcheck => '0',
  }

  file { '/usr/local/stanford-core-nlp':
    ensure => directory,
    owner  => 'deploy',
    group  => 'root',
    mode   => '0755',
  }

  #staging::deploy { 'stanford-core-nlp-full.zip':
  #  source  => 'http://louismullie.com/treat/stanford-core-nlp-full.zip',
  #  target  => '/usr/local',
  #  require => [Package['unzip'],File['/usr/local/stanford-core-nlp']],
  #  owner   => 'deploy',
  #  group   => 'root',

  #}

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
    'ruby-2.2.1':
      ensure      => 'present',
      default_use => false;
  }

  rvm_gem {
    'bundler':
      name         => 'bundler',
      ruby_version => 'ruby-2.2.1',
      ensure       => latest,
      require      => Rvm_system_ruby['ruby-2.2.1'];
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

    package { 'postgresql94-devel':
      ensure => installed,
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
