node casefinder {
  include rvm

  rvm_system_ruby {
    'ruby-2.1':
      ensure      => 'present',
      default_use => false;
    'ruby-2.2':
      ensure      => 'present',
      default_use => false;
  }

  include apache

  #  class { 'rvm::passenger::apache':
  #    version            => '4.0.59',
  #    ruby_version       => 'ruby-2.2',
  #    mininstances       => '4',
  #    maxinstancesperapp => '0',
  #    maxpoolsize        => '30',
  #  }

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
}

}
