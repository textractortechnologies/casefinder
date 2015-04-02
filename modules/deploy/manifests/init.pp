class deploy ($http_packages = $::webserver::params::packages) inherits webserver::params {
  include deploy::user, deploy::sudo, deploy::sudoers, deploy::keys, deploy::colorprompt, deploy::logrotate

   Package[$packages] -> Class['deploy::user']
}
