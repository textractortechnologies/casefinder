class deploy::user{
  file { '/var/www':
    ensure => directory,
    mode   => '0775',
    owner  => 'deploy',
    group  => 'deploy',
  }

  file { '/var/www/apps':
    ensure  => directory,
    mode    => '0775',
    owner   => 'deploy',
    group   => 'deploy',
    require => File['/var/www'],
  } ->

  file { '/var/www/apps/tmp':
    ensure => directory,
    mode   => '0755',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
