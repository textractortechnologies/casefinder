node casefinder {
  include rvm
  include webserver
  include webserver::passenger
  include epel
  include deploy


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

  group { 'deploy':
    ensure => present,
    gid    => '599',
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
