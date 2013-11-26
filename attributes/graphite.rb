default['graphite']['carbon']['package'] = 'py27-carbon'
default['graphite']['carbon']['local_data_dir'] = '/opt/graphite/storage/whisper'
default['graphite']['carbon']['listen_attribute'] = 'ipaddress'
default['graphite']['carbon']['user'] = 'graphite'
default['graphite']['carbon']['group'] = 'graphite'

#default[:graphite][:graphite_web][:uri] = "http://launchpadlibrarian.net/82112308/graphite-web-#{node[:graphite][:version]}.tar.gz"
#default[:graphite][:graphite_web][:checksum] = "cc78bab7fb26b"
#
#default[:graphite][:carbon][:line_receiver_interface] =   "127.0.0.1"
#default[:graphite][:carbon][:pickle_receiver_interface] = "127.0.0.1"
#default[:graphite][:carbon][:cache_query_interface] =     "127.0.0.1"
#
#default[:graphite][:password] = "change_me"
#default[:graphite][:url] = "graphite"
