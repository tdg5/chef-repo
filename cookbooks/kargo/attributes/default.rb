architecture = node['kernel']['machine']
default['kargo']['architecture'] = (
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

default['kargo']['download_url_template'] = 'https://github.com/akuity/kargo/releases/download/v%{version}/kargo-%{operating_system}-%{architecture}'

default['kargo']['install']['group'] = node['root_user']['group']
default['kargo']['install']['prefix'] = '/usr/local/bin'
default['kargo']['install']['username'] = node['root_user']['username']

default['kargo']['operating_system'] = node['os']

default['kargo']['version'] = '1.12.5'
