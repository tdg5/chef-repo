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

  execute "ufw allow #{port}/#{proto} from #{lan}" do
    command "ufw allow from #{lan} to any port #{port} proto #{proto} comment '#{comment}'"
    not_if "ufw status | grep -qE '^#{port}/#{proto}[[:space:]]+ALLOW[[:space:]]+#{Regexp.escape(lan)}'"
  end
end

if node['ufw']['enabled']
  execute 'ufw --force enable' do
    not_if 'ufw status | grep -q "Status: active"'
  end
end
