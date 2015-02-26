class vagrant::metamorphoo {

  $metamorphoo_profiles = hiera_hash('pri::config::metamorphoo_profiles')

  if $metamorphoo_profiles {

  }
}

