architecture = node['kernel']['machine']
default['sops']['architecture'] = (
  if architecture == 'x86_64'
    'amd64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  end
)

default['sops']['download_url_template'] = 'https://github.com/getsops/sops/releases/download/v%{version}/sops-v%{version}.%{operating_system}.%{architecture}'

default['sops']['install']['group'] = node['root_user']['group']
default['sops']['install']['prefix'] = '/usr/local/bin'
default['sops']['install']['username'] = node['root_user']['username']

default['sops']['operating_system'] = node['os']

default['sops']['version'] = '3.8.1'
