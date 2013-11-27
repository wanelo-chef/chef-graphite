default['graphite']['carbon']['package'] = 'py27-carbon'
default['graphite']['carbon']['local_data_dir'] = '/opt/graphite/storage/whisper'
default['graphite']['carbon']['listen_attribute'] = 'ipaddress'
default['graphite']['carbon']['user'] = 'graphite'
default['graphite']['carbon']['group'] = 'graphite'

default['graphite']['web']['packages'] = %w(py27-expat py27-graphite-web)
default['graphite']['web']['listen_attribute'] = 'ipaddress'
default['graphite']['web']['port'] = 8080
default['graphite']['web']['user'] = 'graphite'
default['graphite']['web']['group'] = 'graphite'
default['graphite']['web']['workers'] = 10

default['graphite']['web']['allowed_hosts'] = []
default['graphite']['web']['secret_key'] = ''

default['graphite']['proxy']['listen'] = 80
default['graphite']['proxy']['server_name'] = ''
default['graphite']['proxy']['server_aliases'] = []

