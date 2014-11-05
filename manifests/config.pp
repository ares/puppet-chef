class chef::config {
  file { 'chef-server.rb':
    path    => '/etc/opscode/chef-server.rb',
    content => template('chef/chef-server.rb.erb')
  } ->
  exec { 'chef-server-reconfigure':
    command     => '/usr/bin/chef-server-ctl reconfigure',
    path        => '/opt/opscode/embedded/bin/:/usr/bin:/usr/sbin:/bin:/sbin',
    environment => ['HOME=/var/opt/opscode/rabbitmq'],
    # uncomment if you don't want to reconfigure chef every time (takes more time but is safer)
    # creates     => '/opt/chef'
  } ->
  file { '/var/lib/puppet/ssl/private_keys/allin.example.com.pem':
    source => '/var/opt/opscode/nginx/ca/allin.example.com.key',
    ensure => 'present',
  } ->
  file { '/var/lib/puppet/ssl/certs/allin.example.com.pem':
    source => '/var/opt/opscode/nginx/ca/allin.example.com.crt',
    ensure => 'present',
  } ->
  file { '/var/lib/puppet/ssl/certs/ca.pem':
    target => '/var/lib/puppet/ssl/certs/allin.example.com.pem',
    ensure => 'link',
  }

  class { 'apache::mod::proxy': }
  class { 'apache::mod::proxy_http': }

  if $foreman::passenger  {
    foreman::config::passenger::fragment { 'chef-proxy.conf':
      ssl_content => template('chef/chef-proxy.conf.erb'),
    }
  }

}
