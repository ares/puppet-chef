class chef::install {

  if $chef::configure_chef_repo {
    include packagecloud

    $repo_type = $::osfamily ? {
      /^(RedHat|CentOS)$/ => 'rpm',
      /^(Debian|Ubuntu)$/ => 'deb',
      default             => 'gem',
    }
  
    packagecloud::repo { "chef/stable":
      type => $repo_type,  # "rpm" or "deb" or "gem"
      before => Package['chef-server-core']
    }
  }

  case $::osfamily {
    'RedHat', 'CentOS': {
      package { 'chef-server-core':
        ensure => 'installed',
        source => $source,
        provider => 'rpm'
      }
    }
    'Ubuntu': {
      package { 'chef-server-core':
        ensure => 'installed',
        source => $source
      }
    }
    # Unfortunatelly, chef packages are built only for EL and Ubuntu
    default: { fail("Unsupported OS family $::osfamily") }
  }

}
