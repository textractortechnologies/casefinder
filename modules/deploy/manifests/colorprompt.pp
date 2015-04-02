class deploy::colorprompt ( $env = $environment) {

  file { '/etc/profile.d/colorprompt.sh':
    ensure  => file,
    content => template('deploy/colorprompt.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }
}
