class webserver::static(
  $confdir = $webserver::params::confdir,
)
inherits webserver::params
{
  define config_file ($filename,$templatename, $confdir = $webserver::static::confdir) {
    file { "${confdir}/${$filename}":
      ensure  => file,
      mode    => 0644,
      owner   => 'deploy',
      group   => 'apache',
      content => template("webserver/${templatename}")
    }
  }
}

