# Configure ufw with a default-deny inbound policy and LAN-scoped allow rules.
# Mirrors the manual setup from plan-zendesk-to-k8s.md Phase 2.2. All rules are
# added before the firewall is enabled so SSH is never cut off.

package 'ufw'

lan = node['ufw']['lan_cidr']

execute 'ufw default deny incoming' do
  not_if 'ufw status verbose | grep -q "deny (incoming)"'
end

execute 'ufw default allow outgoing' do
  not_if 'ufw status verbose | grep -q "allow (outgoing)"'
end

node['ufw']['allow'].each do |rule|
  port = rule['port']
  proto = rule['proto']
  comment = rule['comment']
  # Rules default to the LAN CIDR; a rule may set 'from' (e.g. 'any') to widen
  # its source, used to expose a router-forwarded port to the internet.
  source = rule['from'] || lan
  # ufw normalises `from any` to "Anywhere" in `ufw status` output.
  status_source = source == 'any' ? 'Anywhere' : Regexp.escape(source)

  execute "ufw allow #{port}/#{proto} from #{source}" do
    command "ufw allow from #{source} to any port #{port} proto #{proto} comment '#{comment}'"
    not_if "ufw status | grep -qE '^#{port}/#{proto}[[:space:]]+ALLOW[[:space:]]+#{status_source}'"
  end
end

# Blanket allows for trusted CIDRs (e.g. k3s pod/service networks).
node['ufw']['allow_from'].each do |cidr|
  execute "ufw allow from #{cidr}" do
    not_if "ufw status | grep -qF '#{cidr}'"
  end
end

if node['ufw']['enabled']
  execute 'ufw --force enable' do
    not_if 'ufw status | grep -q "Status: active"'
  end
end

# FORWARD-chain default policy. Routed Kubernetes traffic needs ACCEPT; a reload
# re-reads /etc/default/ufw so the change takes effect.
forward_policy = node['ufw']['forward_policy']
execute 'set ufw forward policy' do
  command "sed -ri 's/^DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY=\"#{forward_policy}\"/' /etc/default/ufw"
  not_if "grep -q '^DEFAULT_FORWARD_POLICY=\"#{forward_policy}\"' /etc/default/ufw"
  notifies :run, 'execute[ufw reload]', :delayed
end

execute 'ufw reload' do
  action :nothing
end
