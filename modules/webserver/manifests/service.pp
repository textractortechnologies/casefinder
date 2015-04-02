class webserver::service (
$service  = $webserver::params::service,
$packages = $webserver::params::packages
)
inherits webserver::params
  {

  service { $service:
    ensure  => running,
    enable  => true,
    require => Package[$packages],
  }

}
