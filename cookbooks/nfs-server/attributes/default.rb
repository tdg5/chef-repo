# NFS exports to serve. Each entry: path, network (CIDR allowed to mount), and
# export options. Node-specific, so set this in the policyfile. Empty by default
# so the cookbook is a no-op until exports are declared.
#
# Avoid no_root_squash unless a provisioner requires it (security). NFSv4
# clients reach these on port 2049 only (already opened in the ufw cookbook).
default['nfs_server']['exports'] = []
