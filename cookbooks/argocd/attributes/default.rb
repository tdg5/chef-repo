architecture = node['kernel']['machine']
default['argocd']['architecture'] = (
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

default['argocd']['download_url_template'] = 'https://github.com/argoproj/argo-cd/releases/download/v%{version}/argocd-%{operating_system}-%{architecture}'

default['argocd']['install']['group'] = node['root_user']['group']
default['argocd']['install']['prefix'] = '/usr/local/bin'
default['argocd']['install']['username'] = node['root_user']['username']

default['argocd']['operating_system'] = node['os']

default['argocd']['version'] = '2.11.1'
