# Install the kernel NFS server and export the bulk-storage disk to the cluster.
# Mirrors plan-zendesk-to-k8s.md Phase 2.4. Run this AFTER cluster-storage so
# the exported path is mounted before it is served.

package 'nfs-kernel-server'

service 'nfs-server' do
  action [:enable, :start]
end

template '/etc/exports' do
  source 'exports.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(exports: node['nfs_server']['exports'])
  notifies :run, 'execute[exportfs -ra]', :delayed
end

# Re-export whenever /etc/exports changes. Runs at the end of the converge, by
# which point nfs-server is up.
execute 'exportfs -ra' do
  action :nothing
end
