module GraphiteHelpers
  def graphite_socket
    ip = node.send node['graphite']['web']['listen_attribute']
    port = node['graphite']['web']['port']
    "#{ip}:#{port}"
  end
end

Chef::Recipe.send :include, GraphiteHelpers
