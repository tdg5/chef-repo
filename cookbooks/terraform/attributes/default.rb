architecture = node['kernel']['machine']
default['terraform']['architecture'] = (
  if architecture == 'x86_64'
    'amd64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  end
)

default['terraform']['download_url_template'] = 'https://releases.hashicorp.com/terraform/%{version}/terraform_%{version}_%{operating_system}_%{architecture}.zip'

default['terraform']['install']['group'] = node['root_user']['group']
default['terraform']['install']['prefix'] = '/usr/local/bin'
default['terraform']['install']['username'] = node['root_user']['username']

default['terraform']['unversioned_symlink']['create'] = true
default['terraform']['unversioned_symlink']['link_type'] = :symbolic

default['terraform']['operating_system'] = node['os']

default['terraform']['tmp_path'] = Chef::Config['file_cache_path']

default['terraform']['version'] = '1.8.3'
