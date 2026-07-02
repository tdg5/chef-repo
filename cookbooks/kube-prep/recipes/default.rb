# Prepare the host kernel for Kubernetes/k3s networking. Mirrors the manual
# steps from plan-zendesk-to-k8s.md Phase 2.3.

modules = node['kube_prep']['modules']

# Persist the modules so they load on every boot.
file '/etc/modules-load.d/kubernetes.conf' do
  content "#{modules.join("\n")}\n"
  mode '0644'
  owner 'root'
  group 'root'
end

# Load them now (idempotent: skipped when already present in lsmod). Must run
# before the net.bridge.* sysctls below, which only exist once br_netfilter is
# loaded.
modules.each do |mod|
  execute "modprobe #{mod}" do
    not_if "lsmod | grep -q '^#{mod}\\b'"
  end
end

# Manage the sysctls via a dedicated drop-in and apply it explicitly. We do NOT
# use the core `sysctl` resource: its apply step runs bare `sysctl -p`, which
# reads /etc/sysctl.conf -- absent on Ubuntu 26.04 -- and fails. Applying our
# own file by path sidesteps that entirely. The drop-in also re-applies on boot
# via systemd-sysctl.
sysctl_conf = '/etc/sysctl.d/99-kubernetes.conf'

file sysctl_conf do
  content(node['kube_prep']['sysctls'].map { |key, value| "#{key} = #{value}" }.join("\n") + "\n")
  mode '0644'
  owner 'root'
  group 'root'
  notifies :run, 'execute[apply kube sysctls]', :immediately
end

# rubocop:disable Chef/Modernize/ExecuteSysctl -- the core `sysctl` resource is
# deliberately avoided here; see the comment above (its `sysctl -p` step fails
# on Ubuntu 26.04, which has no /etc/sysctl.conf).
execute 'apply kube sysctls' do
  command "sysctl -p #{sysctl_conf}"
  action :nothing
end
# rubocop:enable Chef/Modernize/ExecuteSysctl

# Remove legacy per-key drop-ins written by the core `sysctl` resource on
# earlier runs, so each key lives in exactly one file (idempotent no-op once
# they're gone).
node['kube_prep']['sysctls'].each_key do |key|
  file "/etc/sysctl.d/99-chef-#{key}.conf" do
    action :delete
  end
end
