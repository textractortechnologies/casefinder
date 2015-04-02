class webserver::params($httpd_version = $::webserver::httpd_version ) {

  case $httpd_version {
    default: {
      $config   = '/etc/httpd/conf/httpd.conf'
      $service  = 'httpd'
      $confdir  = '/etc/httpd/conf.d'
      $defaults = '/etc/sysconfig/httpd'
      $packages  = ['httpd', 'mod_ssl', 'git']
    }

    '2.4': {
      $config  = '/opt/rh/httpd24/root/etc/httpd/conf/httpd.conf'
      $service = 'httpd24-httpd'
      $confdir = '/opt/rh/httpd24/root/etc/httpd/conf.d'
      $defaults = '/opt/rh/httpd24/root/etc/sysconfig/httpd'
      $packages = ['httpd24-httpd', 'httpd24-mod_ssl', 'git']
    }
  }
}
