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
  }

  file { "/var/lib/puppet/ssl/private_keys/":
    ensure => 'directory',
    mode   => '0750',
    group  => 'puppet',
    require => Exec['chef-server-reconfigure'],
  }

  file { "/var/lib/puppet/ssl/private_keys/${fqdn}.pem":
    source => "/var/opt/opscode/nginx/ca/${fqdn}.key",
    ensure => 'present',
    group  => 'puppet',
    mode   => '0640',
    require => Exec['chef-server-reconfigure'],
  }

  file { "/var/lib/puppet/ssl/certs/${fqdn}.pem":
    source => "/var/opt/opscode/nginx/ca/${fqdn}.crt",
    ensure => 'present',
    require => Exec['chef-server-reconfigure'],
  }

  file { '/var/lib/puppet/ssl/certs/ca.pem':
    target => "/var/lib/puppet/ssl/certs/${fqdn}.pem",
    ensure => 'link',
    require => Exec['chef-server-reconfigure'],
  }

  exec { 'create-organization':
    command => "chef-server-ctl org-create ${chef::default_org_name} 'Foreman default org' --filename /etc/opscode/validation_${chef::default_org_name}.pem",
    path    => '/opt/opscode/embedded/bin/:/usr/bin:/usr/sbin:/bin:/sbin',
    creates => '/etc/opscode/validation_default.pem',
    require => Exec['chef-server-reconfigure'],
  }

  class { 'apache::mod::proxy': }
  class { 'apache::mod::proxy_http': }

  if $foreman::passenger  {
    foreman::config::passenger::fragment { 'chef-proxy.conf':
      ssl_content => template('chef/chef-proxy.conf.erb'),
    }
  }
}
