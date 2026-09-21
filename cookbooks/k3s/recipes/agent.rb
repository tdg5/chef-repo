# Declarative config for a k3s agent (worker) node; see resources/node.rb.
k3s_node 'agent' do
  config node['k3s']['config'].to_hash
  required_mounts Array(node['k3s']['required_mounts'])
end
