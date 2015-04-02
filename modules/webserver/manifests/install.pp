class webserver::install(
  $packages = $webserver::params::packages,
  $confdir  = $webserver::params::confdir,
)

inherits webserver::params

{
  ensure_packages([$packages])

  file { $confdir:
    owner   => 'deploy',
    group   => 'apache',
    mode    => '0773',
    require => Package[$packages],
  }
}
