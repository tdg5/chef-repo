# Manage a k3s node's declarative config, for either role. The initial install
# and the secret join token stay manual (see plan-zendesk-to-k8s.md Phase 3, or
# k8s-at-home's install scripts for the server/agent-1 VMs); this resource only
# owns the reproducible, non-secret config + service state. The resource name is
# the node's role: 'server' manages the `k3s` service, 'agent' the `k3s-agent`
# service.
#
# The k3s VERSION -- the /usr/local/bin/k3s binary -- is deliberately NOT managed
# here. Upgrades are GitOps-driven by system-upgrade-controller in the
# infrastructure repo (kubernetes/services/system-upgrade-controller), which
# swaps the binary in place on every cerberus node and restarts k3s. Don't add
# binary management to this cookbook: the two would fight over the same file.
#
# Note: node labels/taints in config.yaml are applied by the kubelet at
# registration. Editing them here on an already-registered node won't change the
# node (use `kubectl label`/`kubectl taint` for that) -- but it makes a rebuilt
# node come up labelled.

unified_mode true

provides :k3s_node

property :role, String, name_property: true, equal_to: %w(agent server)
property :config, Hash, default: {}
property :required_mounts, Array, default: []

action :configure do
  service_name = new_resource.role == 'server' ? 'k3s' : 'k3s-agent'
  unit_path = "/etc/systemd/system/#{service_name}.service"
  drop_in_dir = "#{unit_path}.d"
  required_mounts = new_resource.required_mounts

  directory '/etc/rancher/k3s' do
    recursive true
    mode '0755'
    owner 'root'
    group 'root'
  end

  # Written BEFORE the ExecStart drop-in below: if k3s happened to restart
  # between the two, a doubled flag (old ExecStart + new config) fails loudly and
  # the delayed restart below then fixes it, whereas the reverse order would
  # briefly run k3s with an old/empty config and no flags at all (on the server
  # that re-enables Traefik/servicelb). to_hash flattens the node Mash so YAML
  # comes out clean (no Mash tags).
  file '/etc/rancher/k3s/config.yaml' do
    content YAML.dump(new_resource.config.to_hash)
    mode '0644'
    owner 'root'
    group 'root'
    notifies :restart, "service[#{service_name}]", :delayed
  end

  execute "#{service_name} systemctl daemon-reload" do
    command 'systemctl daemon-reload'
    action :nothing
  end

  directory drop_in_dir do
    recursive true
    mode '0755'
    owner 'root'
    group 'root'
    only_if { ::File.exist?(unit_path) }
  end

  # Make config.yaml the only source of k3s flags. The get.k3s.io installer bakes
  # any CLI args into the unit's ExecStart (the k8s-at-home VMs were installed
  # that way, token included); reset ExecStart to the bare subcommand so a
  # reinstall or rebuild can't silently layer flags on top of config.yaml. The
  # token/URL still reach k3s via the unit's EnvironmentFile. daemon-reload only:
  # the new ExecStart takes effect on the next start, which the config.yaml change
  # triggers when there is anything to apply -- a node already running bare (the
  # manually-installed agents) needs no bounce.
  file "#{drop_in_dir}/20-exec-start.conf" do
    content "# Managed by Chef (k3s cookbook). Do not edit by hand.\n" \
            "# Flags live in /etc/rancher/k3s/config.yaml; secrets in the env file.\n" \
            "[Service]\n" \
            "ExecStart=\n" \
            "ExecStart=/usr/local/bin/k3s #{new_resource.role}\n"
    mode '0644'
    owner 'root'
    group 'root'
    only_if { ::File.exist?(unit_path) }
    notifies :run, "execute[#{service_name} systemctl daemon-reload]", :immediately
  end

  # Storage-mount ordering guard -- see node['k3s']['required_mounts']. This
  # prevents the kubelet from serving an empty root-fs fallback dir for a `local`
  # PV / local-path volume when a `nofail` disk failed to mount. We do NOT restart
  # here -- the dependency only matters at the next start, and bouncing k3s would
  # needlessly disrupt running pods on a stateful node.
  file "#{drop_in_dir}/10-require-storage-mounts.conf" do
    content "# Managed by Chef (k3s cookbook). Do not edit by hand.\n" \
            "[Unit]\n" \
            "RequiresMountsFor=#{required_mounts.join(' ')}\n"
    mode '0644'
    owner 'root'
    group 'root'
    only_if { ::File.exist?(unit_path) }
    not_if { required_mounts.empty? }
    notifies :run, "execute[#{service_name} systemctl daemon-reload]", :immediately
  end

  # Keep k3s enabled on boot. Guarded so a node that hasn't run the manual
  # install yet (no unit file) simply skips this -- the config.yaml above is still
  # written, ready for when k3s is installed.
  service service_name do
    action :enable
    supports restart: true
    only_if { ::File.exist?(unit_path) }
  end
end
