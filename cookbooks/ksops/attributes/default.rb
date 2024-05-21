architecture = node['kernel']['machine']
default['ksops']['architecture'] = (
  if architecture == 'x86_64'
    'x86_64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  elsif architecture == 'i386'
    'i386'
  elsif architecture == 'i686'
    'i686'
  end
)

default['ksops']['download_url_template'] = 'https://github.com/viaduct-ai/kustomize-sops/releases/download/v%{version}/ksops_%{version}_%{operating_system}_%{architecture}.tar.gz'

default['ksops']['install']['group'] = node['root_user']['group']
default['ksops']['install']['prefix'] = '/usr/local/bin'
default['ksops']['install']['username'] = node['root_user']['username']

operating_system = node['os'].downcase
default['ksops']['operating_system'] = (
  if /^linux/ =~ operating_system
    'Linux'
  elsif /^darwin/ =~ operating_system
    'Darwin'
  elsif /^(msys|windowsnt)/ =~ operating_system
    'Windows'
  end
)

default['ksops']['unversioned_symlink']['create'] = true
default['ksops']['unversioned_symlink']['link_type'] = :symbolic

default['ksops']['tmp_path'] = Chef::Config['file_cache_path']

default['ksops']['version'] = '4.3.1'
