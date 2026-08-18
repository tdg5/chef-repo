install_group = node['golang']['install']['group']
install_prefix = node['golang']['install']['prefix']
install_username = node['golang']['install']['username']

version = node['golang']['version']

download_url = node['golang']['download_url'] ||
               format(node['golang']['download_url_template'], architecture: node['golang']['architecture'], operating_system: node['golang']['operating_system'], version: version)

tmp_path = node['golang']['tmp_path']
version_name = "go-#{version}"

archive_file_path = ::File.join(
  tmp_path,
  "#{version_name}.tar.gz"
)

version_install_path = ::File.join(install_prefix, version_name)

# Fetch archive containing desired go version
remote_file 'golang_version_archive' do
  action :create
  not_if { ::File.exist?(version_install_path) }
  path archive_file_path
  source download_url
end

# Extract desired go version to versioned install path, dropping the archive's
# top-level 'go' directory so the payload lands directly in the versioned path
archive_file 'golang_version_payload' do
  destination version_install_path
  group install_group
  mode '0755'
  not_if { ::File.exist?(version_install_path) }
  notifies :delete, 'file[golang_version_archive]', :immediately
  owner install_username
  path archive_file_path
  strip_components 1
end

goroot_path = ::File.join(install_prefix, 'go')

# Create symlink from desired go version to go (i.e. without version)
link 'golang_goroot_symlink' do
  link_type node['golang']['unversioned_symlink']['link_type']
  only_if { node['golang']['unversioned_symlink']['create'] }
  target_file goroot_path
  to version_install_path
end

bin_source_path = (
  if node['golang']['unversioned_symlink']['create']
    goroot_path
  else
    version_install_path
  end
)

# Link go binaries onto the default PATH
node['golang']['bin_symlinks'].each do |binary|
  link "golang_#{binary}_symlink" do
    link_type :symbolic
    target_file ::File.join(node['golang']['bin_prefix'], binary)
    to ::File.join(bin_source_path, 'bin', binary)
  end
end

# Clean up archive
file 'golang_version_archive' do
  action :nothing
  path archive_file_path
end
