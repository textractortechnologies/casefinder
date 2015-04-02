class webserver::sslconfig ($confdir = $::webserver::params::confdir ) {

  file { "$confdir/ssl.conf":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("webserver/ssl.conf.erb"),

  }
}
