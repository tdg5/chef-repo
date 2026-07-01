# Helm no longer ships an apt repository -- the old baltocdn.com endpoint was
# decommissioned and now returns a stub "OK" for every path, which broke the
# previous `apt_repository` + `package 'helm'` approach. Install the official
# release binary directly instead (mirrors the kustomize cookbook). macOS keeps
# using Homebrew.
install_group = node['helm']['install']['group']
install_prefix = node['helm']['install']['prefix']
install_username = node['helm']['install']['username']

if node['platform_family'] == 'debian'
  # Prepare install path
  directory 'helm_install_prefix' do
    group install_group
    mode '0755'
    path install_prefix
    recursive true
    user install_username
  end

  version = node['helm']['version']

  download_url = (
    node['helm']['download_url'] ||
    node['helm']['download_url_template'] % {
      architecture: node['helm']['architecture'],
      operating_system: node['helm']['operating_system'],
      version: version,
    }
  )

  tmp_path = node['helm']['tmp_path']
  version_name = "helm-#{version}"

  archive_file_path = ::File.join(tmp_path, "#{version_name}.tar.gz")
  version_binary_path = ::File.join(install_prefix, version_name)

  # Fetch archive containing the desired helm version
  remote_file 'helm_version_archive' do
    action :create
    not_if { ::File.exist?(version_binary_path) }
    path archive_file_path
    source download_url
  end

  archive_destination_path = ::File.join(tmp_path, version_name)

  # Extract archive containing the desired helm version
  archive_file 'helm_version_payload' do
    destination archive_destination_path
    mode '0755'
    not_if { ::File.exist?(version_binary_path) }
    path archive_file_path
  end

  # Helm's tarball nests the binary under <os>-<arch>/helm
  extracted_binary_path = ::File.join(
    archive_destination_path,
    "#{node['helm']['operating_system']}-#{node['helm']['architecture']}",
    'helm'
  )

  # Copy the desired helm version to the install path
  remote_file 'helm_version_copy' do
    action :create_if_missing
    group install_group
    mode '0755'
    not_if { ::File.exist?(version_binary_path) }
    notifies :delete, 'directory[helm_version_payload]', :immediately
    notifies :delete, 'file[helm_version_archive]', :immediately
    path version_binary_path
    source "file://#{extracted_binary_path}"
    user install_username
  end

  binary_path = ::File.join(install_prefix, 'helm')

  # Create symlink from the versioned helm to unversioned `helm`
  link 'helm_symlink' do
    link_type node['helm']['unversioned_symlink']['link_type']
    only_if { node['helm']['unversioned_symlink']['create'] }
    target_file binary_path
    to version_binary_path
  end

  # Clean up extracted archive
  directory 'helm_version_payload' do
    action :nothing
    path archive_destination_path
    recursive true
  end

  # Clean up archive
  file 'helm_version_archive' do
    action :nothing
    path archive_file_path
  end
elsif node['platform'] == 'mac_os_x'
  package 'helm'
end
