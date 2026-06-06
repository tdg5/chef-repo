# Manage the k3s agent's declarative node config. The install itself and the
# secret node-token stay manual (see plan-zendesk-to-k8s.md Phase 3); this
# cookbook only owns the reproducible, non-secret config + service state.
#
# Note: node labels in config.yaml are applied by the kubelet at registration.
# Editing them here on an already-registered node won't relabel it (use
# `kubectl label` for that) -- but it makes a rebuilt node come up labelled.

directory '/etc/rancher/k3s' do
  recursive true
  mode '0755'
  owner 'root'
  group 'root'
end

# Render the config hash to YAML. to_hash flattens the node Mash so YAML comes
# out clean (no Mash tags).
config = node['k3s_agent']['config'].to_hash

file '/etc/rancher/k3s/config.yaml' do
  content config.to_yaml
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[k3s-agent]', :delayed
end

# Keep the agent enabled on boot. Guarded so a node that hasn't run the manual
# install yet (no unit file) simply skips this -- the config.yaml above is still
# written, ready for when the agent is installed.
service 'k3s-agent' do
  action :enable
  supports restart: true
  only_if { ::File.exist?('/etc/systemd/system/k3s-agent.service') }
end
