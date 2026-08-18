architecture = node['kernel']['machine']
default['golang']['architecture'] = (
  if architecture == 'x86_64'
    'amd64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  end
)

# Go binaries to link onto the default PATH so tooling (and the GOPATH/GOBIN
# setup in .bashrc) can find the toolchain without shell configuration.
default['golang']['bin_prefix'] = '/usr/local/bin'
default['golang']['bin_symlinks'] = %w( go gofmt )

default['golang']['download_url_template'] = 'https://go.dev/dl/go%{version}.%{operating_system}-%{architecture}.tar.gz'

default['golang']['install']['group'] = node['root_user']['group']
default['golang']['install']['prefix'] = '/usr/local'
default['golang']['install']['username'] = node['root_user']['username']

# node['os'] is 'linux' or 'darwin', matching Go's release artifact naming
default['golang']['operating_system'] = node['os']

default['golang']['tmp_path'] = Chef::Config['file_cache_path']

default['golang']['unversioned_symlink']['create'] = true
default['golang']['unversioned_symlink']['link_type'] = :symbolic

default['golang']['version'] = '1.26.6'
