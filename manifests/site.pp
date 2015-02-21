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

  class { 'rvm::passenger::apache':
    version            => '4.0.59',
    ruby_version       => 'ruby-2.2',
    mininstances       => '4',
    maxinstancesperapp => '0',
    maxpoolsize        => '30',
  }

}
