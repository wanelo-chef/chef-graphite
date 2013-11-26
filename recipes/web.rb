require 'securerandom'

include_recipe 'smf'

node['graphite']['web']['packages'].each do |pkg|
  package pkg
end

service 'graphite-web' do
  supports :restart => true, :reload => true, :enable => true, :disable => true
  action :nothing
end

directory '/var/log/graphite' do
  group node['graphite']['web']['group']
  mode 0774
end

%w(info exception).each do |log|
  file "/var/log/graphite/#{log}.log" do
    group node['graphite']['web']['group']
    mode 0774
    action :create_if_missing
  end
end

node.set_unless['graphite']['web']['secret_key'] = SecureRandom.base64(64)

template '/opt/local/lib/python2.7/site-packages/graphite/app_settings.py' do
  owner node['graphite']['web']['user']
  group node['graphite']['web']['group']
  variables 'allowed_hosts' => node['graphite']['web']['allowed_hosts'],
            'secret_key' => node['graphite']['web']['secret_key']
  notifies :restart, 'service[graphite-web]'
end

template '/opt/local/lib/python2.7/site-packages/graphite/local_settings.py' do
  owner node['graphite']['web']['user']
  group node['graphite']['web']['group']
  notifies :restart, 'service[graphite-web]'
end

execute 'install graphite sqlite database' do
  command 'python /opt/local/lib/python2.7/site-packages/graphite/manage.py syncdb --settings=graphite.settings  --noinput'
  cwd '/opt/local/lib/python2.7/site-packages/graphite'
  user node['graphite']['web']['user']
  group node['graphite']['web']['group']
  environment 'HOME' => '/opt/graphite/storage',
              'LANG' => 'en_US.UTF-8',
              'LC_ALL' => 'en_US.UTF-8',
              'PYTHONPATH' => '/opt/graphite:/opt/local/lib/python2.7/site-packages/graphite:/opt/local/lib/python2.7'
  not_if { File.exists?('/opt/graphite/storage/graphite.db')}
end

listen_address = node.send node['graphite']['web']['listen_attribute']

smf 'graphite-web' do
  manifest_type 'graphite'
  user node['graphite']['web']['user']
  group node['graphite']['web']['group']
  start_command '/opt/local/bin/django-admin.py runserver --pythonpath=$PYTHONPATH --settings=graphite.settings %{config/bind_address}:%{config/bind_port} &'
  stop_timeout 60

  working_directory '/opt/graphite'

  property_groups({
    'config' => {
      'bind_address' => listen_address,
      'bind_port' => node['graphite']['web']['port']
    }
  })

  environment 'LANG' => 'en_US.UTF-8',
              'LC_ALL' => 'en_US.UTF-8',
              'PYTHONPATH' => '/opt/graphite:/opt/local/lib/python2.7/site-packages/graphite:/opt/local/lib/python2.7'

  notifies :restart, 'service[graphite-web]'
end
