class deploy::sudo {

  file { '/etc/sudoers.d/10_deploy':
    ensure  => present,
    content => "%deploy	ALL=(ALL)	NOPASSWD: ALL\n"
  }



}
