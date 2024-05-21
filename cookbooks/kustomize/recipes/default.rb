# Some ideas adapted from https://raw.githubusercontent.com/kubernetes-sigs/kustomize/3c44db87468e755ba76c52a2fef1da7da0c10e9f/hack/install_kustomize.sh

install_group = node['kustomize']['install']['group']
install_prefix = node['kustomize']['install']['prefix']
install_username = node['kustomize']['install']['username']

# Prepare install path
directory 'kustomize_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['kustomize']['version']

download_url = (
  node['kustomize']['download_url'] ||
  node['kustomize']['download_url_template'] % {
    architecture: node['kustomize']['architecture'],
    operating_system: node['kustomize']['operating_system'],
    version: version,
  }
)

tmp_path = node['kustomize']['tmp_path']
version_name = "kustomize-#{version}"

archive_file_path = ::File.join(
  tmp_path,
  "#{version_name}.tar.gz"
)

version_binary_path = ::File.join(install_prefix, version_name)

# Fetch archive containing desired kustomize version
remote_file 'kustomize_version_archive' do
  action :create
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
  source download_url
end

archive_destination_path = ::File.join(tmp_path, version_name)

# Extract archive containined desired kustomize version
archive_file 'kustomize_version_payload' do
  destination archive_destination_path
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
end

# Copy desired kustomize version to install path
remote_file 'kustomize_version_copy' do
  action :create_if_missing
  group install_group
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  notifies :delete, 'directory[kustomize_version_payload]', :immediately
  notifies :delete, 'file[kustomize_version_archive]', :immediately
  path version_binary_path
  source "file://#{::File.join(archive_destination_path, 'kustomize')}"
  user install_username
end

binary_path = ::File.join(install_prefix, 'kustomize')

# Create symlink from desired kustomize version to kustomize (i.e. without version)
link 'kustomize_symlink' do
  link_type node['kustomize']['unversioned_symlink']['link_type']
  only_if { node['kustomize']['unversioned_symlink']['create'] }
  target_file binary_path
  to version_binary_path
end

# Clean up extracted archive
directory 'kustomize_version_payload' do
  action :nothing
  path archive_destination_path
  recursive true
end

# Clean up archive
file 'kustomize_version_archive' do
  action :nothing
  path archive_file_path
end
