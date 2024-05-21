architecture = node['kernel']['machine']
default['minikube']['architecture'] = (
  if architecture == 'x86_64'
    'amd64'
  elsif architecture == 'aarch64' || architecture == 'arm64'
    'arm64'
  end
)

default['minikube']['download_url_template'] = 'https://storage.googleapis.com/minikube/releases/%{version}/minikube-%{operating_system}-%{architecture}'

default['minikube']['install']['group'] = node['root_user']['group']
default['minikube']['install']['prefix'] = '/usr/local/bin'
default['minikube']['install']['username'] = node['root_user']['username']

default['minikube']['operating_system'] = node['os']

default['minikube']['version'] = 'latest'
