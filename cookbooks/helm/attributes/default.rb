architecture = node['kernel']['machine']
default['helm']['architecture'] = (
  if architecture == 'x86_64'
    'amd64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  elsif architecture == 'ppc64le'
    'ppc64le'
  elsif architecture == 's390x'
    's390x'
  end
)

# Helm's official binary archives. Layout: helm-v<version>-<os>-<arch>.tar.gz,
# extracting to <os>-<arch>/helm.
default['helm']['download_url_template'] = 'https://get.helm.sh/helm-v%{version}-%{operating_system}-%{architecture}.tar.gz'

default['helm']['install']['group'] = node['root_user']['group']
default['helm']['install']['prefix'] = '/usr/local/bin'
default['helm']['install']['username'] = node['root_user']['username']

default['helm']['unversioned_symlink']['create'] = true
default['helm']['unversioned_symlink']['link_type'] = :symbolic

default['helm']['operating_system'] = node['os']

default['helm']['tmp_path'] = Chef::Config['file_cache_path']

# Helm 4.x. Note Helm 4 has breaking changes relative to Helm 3 (which the old
# baltocdn apt repo served) -- review your charts/plugins if upgrading in place.
default['helm']['version'] = '4.2.2'
