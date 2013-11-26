
include_recipe 'smf'

package node['graphite']['carbon']['package']

service 'carbon-cache' do
  supports :restart => true, :reload => true, :enable => true, :disable => true
  action :nothing
end

directory '/var/log/carbon' do
  group node['graphite']['web']['group']
  mode 0774
end

directory '/var/run/carbon' do
  group node['graphite']['web']['group']
  mode 0774
end

smf 'carbon-cache' do
  manifest_type 'graphite'
  user node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
  start_command '/opt/local/bin/carbon-cache.py --config=/opt/local/etc/graphite/carbon.conf start'
  stop_timeout 60
  working_directory '/opt/graphite'
end

directory '/opt/graphite/storage' do
  recursive true
  owner node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
  mode 0775
end

directory node['graphite']['carbon']['local_data_dir'] do
  recursive true
  owner node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
end

listen_address = node.send node['graphite']['carbon']['listen_attribute']

template '/opt/local/etc/graphite/carbon.conf' do
  variables( 'local_data_dir' => node['graphite']['carbon']['local_data_dir'],
             'line_receiver_interface' => listen_address,
             'pickle_receiver_interface' => listen_address,
             'cache_query_interface' => listen_address )
  notifies :restart, 'service[carbon-cache]'
end

#
#template '/opt/graphite/conf/storage-schemas.conf' do
#  owner node['graphite']['carbon']['user']
#  group node['graphite']['carbon']['group']
#end
#
#execute 'carbon: change graphite storage permissions to apache user' do
#  command "chown -R #{node['graphite']['carbon']['user']}:#{node['graphite']['carbon']['group']} /opt/graphite/storage"
#  only_if do
#    f = File.stat('/opt/graphite/storage')
#    f.uid == 0 and f.gid == 0
#  end
#end
#
#directory '/opt/graphite/lib/twisted/plugins/' do
#  owner node['graphite']['carbon']['user']
#  group node['graphite']['carbon']['group']
#end
