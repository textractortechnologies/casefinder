class deploy::logrotate {

  file { '/etc/logrotate.d/rails.conf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('deploy/rails_logrotate.conf.erb'),
  }
}
