# == Class: chef server
#
# This class installs and configures chef server
#
# === Parameters:
#
# $configure_chef_repo::           Should we configure official chef repo to download chef package?
#                                  type: boolean
#
# $default_org_name::              This org will be created on chef server and set to be used in
#                                  foreman_proxy config
#
class chef (
  $configure_chef_repo           = $chef::params::configure_chef_repo,
  $default_org_name              = $chef::params::default_org_name,
) inherits chef::params {
  class { 'chef::install': } ->
  class { 'chef::config': }
}
