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
    }
  }

  package { 'chef-server-core':
    ensure => 'installed',
    source => $source,
    provider => 'rpm'
  }

}
