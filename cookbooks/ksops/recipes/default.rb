# Some ideas adapted from https://raw.githubusercontent.com/viaduct-ai/kustomize-sops/04824d503d17461ca34d988cbdb97710bd4bfc6e/scripts/install-ksops-archive.sh

install_group = node['ksops']['install']['group']
install_prefix = node['ksops']['install']['prefix']
install_username = node['ksops']['install']['username']

# Prepare install path
directory 'ksops_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['ksops']['version']

download_url = (
  node['ksops']['download_url'] ||
  node['ksops']['download_url_template'] % {
    architecture: node['ksops']['architecture'],
    operating_system: node['ksops']['operating_system'],
    version: version,
  }
)

tmp_path = node['ksops']['tmp_path']
version_name = "ksops-#{version}"

archive_file_path = ::File.join(
  tmp_path,
  "#{version_name}.tar.gz"
)

version_binary_path = ::File.join(install_prefix, version_name)

# Fetch archive containing desired ksops version
remote_file 'ksops_version_archive' do
  action :create
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
  source download_url
end

archive_destination_path = ::File.join(tmp_path, version_name)

# Extract archive containined desired ksops version
archive_file 'ksops_version_payload' do
  destination archive_destination_path
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
end

# Copy desired ksops version to install path
remote_file 'ksops_version_copy' do
  action :create_if_missing
  group install_group
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  notifies :delete, 'directory[ksops_version_payload]', :immediately
  notifies :delete, 'file[ksops_version_archive]', :immediately
  path version_binary_path
  source "file://#{::File.join(archive_destination_path, 'ksops')}"
  user install_username
end

binary_path = ::File.join(install_prefix, 'ksops')

# Create symlink from desired ksops version to ksops (i.e. without version)
link 'ksops_symlink' do
  link_type node['ksops']['unversioned_symlink']['link_type']
  only_if { node['ksops']['unversioned_symlink']['create'] }
  target_file binary_path
  to version_binary_path
end

# Clean up extracted archive
directory 'ksops_version_payload' do
  action :nothing
  path archive_destination_path
  recursive true
end

# Clean up archive
file 'ksops_version_archive' do
  action :nothing
  path archive_file_path
end
