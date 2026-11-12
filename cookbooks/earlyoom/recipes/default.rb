# earlyoom kills the most expendable process before the system runs out of
# memory, rather than letting the kernel OOM killer fire after the box has
# already ground to a halt.
home_directory = node['user']['home_directory']
group_name = node['user']['group']
username = node['user']['username']

package 'earlyoom'

template '/etc/default/earlyoom' do
  source 'earlyoom.erb'
  group node['root_user']['group']
  mode '0644'
  notifies :restart, 'systemd_unit[earlyoom.service]', :immediately
  owner node['root_user']['username']
end

systemd_unit 'earlyoom.service' do
  action [:enable, :start]
end

# Takes effect on the user's next login (or `systemctl --user daemon-reexec`).
%w(.config .config/systemd .config/systemd/user.conf.d).each do |dir|
  directory "#{home_directory}/#{dir}" do
    group group_name
    mode '0755'
    owner username
  end
end

cookbook_file "#{home_directory}/.config/systemd/user.conf.d/oom.conf" do
  source 'systemd-user-oom.conf'
  group group_name
  mode '0644'
  owner username
end
