install_group = node['terraform']['install']['group']
install_prefix = node['terraform']['install']['prefix']
install_username = node['terraform']['install']['username']

# Prepare install path
directory 'terraform_install_prefix' do
  group install_group
  mode '0755'
  path install_prefix
  recursive true
  user install_username
end

version = node['terraform']['version']

download_url = (
  node['terraform']['download_url'] ||
  node['terraform']['download_url_template'] % {
    architecture: node['terraform']['architecture'],
    operating_system: node['terraform']['operating_system'],
    version: version,
  }
)

tmp_path = node['terraform']['tmp_path']
version_name = "terraform-#{version}"

archive_file_path = ::File.join(
  tmp_path,
  "#{version_name}.tar.gz"
)

version_binary_path = ::File.join(install_prefix, version_name)

# Fetch archive containing desired terraform version
remote_file 'terraform_version_archive' do
  action :create
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
  source download_url
end

archive_destination_path = ::File.join(tmp_path, version_name)

# Extract archive containined desired terraform version
archive_file 'terraform_version_payload' do
  destination archive_destination_path
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  path archive_file_path
end

# Copy desired terraform version to install path
remote_file 'terraform_version_copy' do
  action :create_if_missing
  group install_group
  mode '0755'
  not_if { ::File.exists?(version_binary_path) }
  notifies :delete, 'directory[terraform_version_payload]', :immediately
  notifies :delete, 'file[terraform_version_archive]', :immediately
  path version_binary_path
  source "file://#{::File.join(archive_destination_path, 'terraform')}"
  user install_username
end

binary_path = ::File.join(install_prefix, 'terraform')

# Create symlink from desired terraform version to terraform (i.e. without version)
link 'terraform_symlink' do
  link_type node['terraform']['unversioned_symlink']['link_type']
  only_if { node['terraform']['unversioned_symlink']['create'] }
  target_file binary_path
  to version_binary_path
end

# Clean up extracted archive
directory 'terraform_version_payload' do
  action :nothing
  path archive_destination_path
  recursive true
end

# Clean up archive
file 'terraform_version_archive' do
  action :nothing
  path archive_file_path
end
