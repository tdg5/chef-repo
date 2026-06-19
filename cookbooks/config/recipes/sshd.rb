root_group = node['root_user']['group']
root_username = node['root_user']['username']

# Drop-in disabling password-based SSH. Named with a `00-` prefix so sshd reads
# it before cloud-init's 50-cloud-init.conf (first value for a keyword wins).
cookbook_file '/etc/ssh/sshd_config.d/00-hardening.conf' do
  source 'sshd-hardening.conf'
  group root_group
  mode '0644'
  notifies :restart, 'systemd_unit[ssh.service]', :immediately
  owner root_username
end

systemd_unit 'ssh.service' do
  action :nothing
end
