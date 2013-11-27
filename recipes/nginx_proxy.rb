include_recipe 'nginx'

graphite_upstream = graphite_socket

server_name = node['graphite']['proxy']['server_name'] || node['fqdn']
server_names = Array(server_name).concat(node['graphite']['proxy']['server_aliases'])

template "#{node['nginx']['dir']}/sites-available/graphite.conf" do
  source 'nginx.conf.erb'
  cookbook 'graphite'
  owner 'root'
  group 'root'
  mode '0644'

  variables 'graphite_upstream' => graphite_upstream,
            'listen' => node['graphite']['proxy']['listen'],
            'server_names' => server_names

  if File.exists?("#{node['nginx']['dir']}/sites-enabled/graphite.conf")
    notifies :reload, 'service[nginx]'
  end
end

nginx_site 'graphite.conf' do
  enable true
end
