
include_recipe 'smf'

package node['graphite']['carbon']['package']

service 'carbon-cache' do
  supports :restart => true, :reload => true, :enable => true, :disable => true
  action :nothing
end

template '/opt/custom/bin/carbon-cache.sh' do
  mode 0755
end

smf 'carbon-cache' do
  manifest_type 'graphite'
  user node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
  start_command '/opt/custom/bin/carbon-cache.sh %m'
  stop_command '/opt/custom/bin/carbon-cache.sh %m'
  stop_timeout 60
  duration 'transient'
end


directory node['graphite']['carbon']['local_data_dir'] do
  recursive true
  owner node['graphite']['carbon']['user']
  group node['graphite']['carbon']['group']
end

listen_interface = node.send node['graphite']['carbon']['listen_attribute']

template '/opt/local/etc/graphite/carbon.conf' do
  variables( 'local_data_dir' => node['graphite']['carbon']['local_data_dir'],
             'line_receiver_interface' => listen_interface,
             'pickle_receiver_interface' => listen_interface,
             'cache_query_interface' => listen_interface )
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
