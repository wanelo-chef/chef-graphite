
include_recipe 'smf'

package node['graphite']['carbon']['package']

service 'graphite' do
  supports :restart => true, :reload => true, :enable => true, :disable => true
  action :nothing
end

listen_address = node.send node['graphite']['web']['listen_attribute']

template '/opt/custom/bin/graphite.sh' do
  mode 0755
  variables 'bind_address' => listen_address,
            'bind_port' => node['graphite']['web']['port']
end

smf 'graphite-web' do
  manifest_type 'graphite'
  user node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
  start_command '/opt/custom/bin/graphite.sh %m'
  stop_command '/opt/custom/bin/graphite.sh %m'
  stop_timeout 60
end


#include_recipe "apache2::mod_python"

#template "/etc/apache2/sites-available/graphite" do
#  source "graphite-vhost.conf.erb"
#end
#
#apache_site "graphite"
#
#directory "/opt/graphite/storage" do
#  owner node['apache']['user']
#  group node['apache']['group']
#end
#
#directory '/opt/graphite/storage/log' do
#  owner node['apache']['user']
#  group node['apache']['group']
#end
#
#%w{ webapp whisper }.each do |dir|
#  directory "/opt/graphite/storage/log/#{dir}" do
#    owner node['apache']['user']
#    group node['apache']['group']
#  end
#end
#
#cookbook_file "/opt/graphite/bin/set_admin_passwd.py" do
#  mode "755"
#end
#
#cookbook_file "/opt/graphite/storage/graphite.db" do
#  action :create_if_missing
#  notifies :run, "execute[set admin password]"
#end
#
#execute "set admin password" do
#  command "/opt/graphite/bin/set_admin_passwd.py root #{node[:graphite][:password]}"
#  action :nothing
#end
#
#file "/opt/graphite/storage/graphite.db" do
#  owner node['apache']['user']
#  group node['apache']['group']
#  mode "644"
#end
