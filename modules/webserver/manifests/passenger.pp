class webserver::passenger {

  $passenger_pkgs = ['rubygem-rack', 'rubygem-passenger',
                    'rubygem-rake', 'rubygem-daemon_controller',
                    'mod_passenger', 'rubygem-passenger-devel',]

  package { $passenger_pkgs:
    ensure => installed,
    notify => Service['httpd'],
  } ->

  apache_directive { 'passenger_friendly_off':
    ensure  => present,
    target  => "/etc/httpd/conf.d/passenger.conf",
    name    => 'PassengerFriendlyErrorPages',
    context => 'IfModule[arg="mod_passenger.c"]',
    args    => 'off',
    notify => Service['httpd'],

  } ->


  apache_directive { 'passenger_max_pool':
    ensure  => present,
    target  => "/etc/httpd/conf.d/passenger.conf",
    name    => 'PassengerMaxPoolSize',
    context => 'IfModule[arg="mod_passenger.c"]',
    args    => '30',
    notify => Service['httpd'],

  } ->

  apache_directive { 'passenger_tmp_directory':
    ensure  => present,
    target  => '/etc/httpd/conf.d/passenger.conf',
    name    => 'PassengerTempDir',
    context => 'IfModule[arg="mod_passenger.c"]',
    args    => '/var/www/apps/tmp',
    notify  => Service['httpd'],
  } ->

  file { '/etc/profile.d/passenger_temp_dir.sh':
    ensure  => file,
    content => "export PASSENGER_TMPDIR=/var/www/apps/tmp\n",
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

}
