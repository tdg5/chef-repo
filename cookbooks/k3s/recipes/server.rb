# Declarative config for the k3s server (control-plane) node; see
# resources/node.rb.
k3s_node 'server' do
  config node['k3s']['config'].to_hash
  required_mounts Array(node['k3s']['required_mounts'])
end
