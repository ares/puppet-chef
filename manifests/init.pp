# == Class: chef server
#
# This class installs and configures chef server
#
# === Parameters:
#
# $configure_chef_repo::           Should we configure official chef repo to download chef package?
#                                  type: boolean
#
# !TODO - somehow validate that foreman::db_type is not postgresql (sqlite or mysql, otherwise conflict with chef)
#       - apache vs nginx conflict -> configure apache to serve chef services (seems like only way)
#       - add more parameters to chef-server config using /etc/opscode/chef-server.rb template
class chef (
  $configure_chef_repo           = $chef::params::configure_chef_repo,
) inherits chef::params {
  class { 'chef::install': } ->
  class { 'chef::config': }
}
