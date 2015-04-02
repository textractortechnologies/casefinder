class postgresql_backup ($backup_path)  {

  file { '/usr/local/bin/pg_backup.config':
    ensure  => file,
    content => template('postgresql_backup/pg_backup.config.erb'),
    mode    => '0400',
    owner   => 'postgres',
    group   => 'root',
  }

  file { '/usr/local/bin/pg_backup_rotated.sh':
    ensure  => file,
    content => template('postgresql_backup/pg_backup_rotated.sh.erb'),
    mode    => '0700',
    owner   => 'postgres',
    group   => 'root',
    require => File['/usr/local/bin/pg_backup.config'],
  }

  cron { 'pg_nightly':
    command => '/usr/local/bin/pg_backup_rotated.sh >> ~/pg_backup.log 2>&1',
    user    => 'postgres',
    minute  => '0',
    hour    => '22',
    require => File['/usr/local/bin/pg_backup_rotated.sh'],
  }


  file { '/var/lib/pgsql/.pgpass':
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0600',
    content => template('postgresql_backup/pgpass.erb'),
    require => Cron['pg_nightly'],
  }

}


