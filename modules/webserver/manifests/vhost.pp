define webserver::vhost(
  $port,
  $docroot,
  $template      = 'webserver/vhost-default.conf.erb',
  $priority      = '25',
  $servername    = '',
  $serveraliases = '',
  $options       = "Indexes FollowSymLinks MultiViews",
  $vhost_name    = '*',
  $packages      = $::webserver::params::packages,
  $service       = $::webserver::params::service,
) inherits webserver::params
{

  include webserver

  Class['deploy'] -> Class['webserver']

  # Below is a pre-2.6.5 idiom for having a parameter default to the title,
  # but you could also just declare $servername = "$title" in the parameters
  # list and change srvname to servername in the template.

  if $servername == '' {
    $srvname = $title
    } else {
      $srvname = $servername
    }
    case $operatingsystem {
      'centos', 'redhat', 'fedora': { $vdir   = '/etc/httpd/conf.d'
      $logdir = '/var/log/httpd'}
      'ubuntu', 'debian':           { $vdir   = '/etc/apache2/sites-enabled'
      $logdir = '/var/log/apache2'}
      default:                      { $vdir   = '/etc/apache2/sites-enabled'
      $logdir = '/var/log/apache2'}
    }
    file {
      "${vdir}/${priority}-${name}.conf":
        content => template($template),
        owner   => 'root',
        group   => 'root',
        mode    => '755',
        require => Package[$packages],
        notify  => Service[$service],
    }

    file { $docroot:
      ensure  => directory,
      owner   => 'deploy',
      group   => 'apache',
      require => File["${vdir}/${priority}-${name}.conf"],
    }

}
