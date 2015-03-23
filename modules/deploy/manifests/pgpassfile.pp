class deploy::pgpassfile {

  $deployable_apps = hiera_hash('deployable_apps')

  file { '/home/deploy/.pgpass':
    ensure  => file,
    owner   => 'deploy',
    group   => 'deploy',
    mode    => 0600,
    content => template('deploy/pgpassfile.erb'),
    require => User['deploy'],
  }
}

