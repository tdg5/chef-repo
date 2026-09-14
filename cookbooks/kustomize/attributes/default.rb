architecture = node['kernel']['machine']
default['kustomize']['architecture'] = (
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

default['kustomize']['download_url_template'] = 'https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%%2Fv%{version}/kustomize_v%{version}_%{operating_system}_%{architecture}.tar.gz'

default['kustomize']['install']['group'] = node['root_user']['group']
default['kustomize']['install']['prefix'] = '/usr/local/bin'
default['kustomize']['install']['username'] = node['root_user']['username']

default['kustomize']['unversioned_symlink']['create'] = true
default['kustomize']['unversioned_symlink']['link_type'] = :symbolic

default['kustomize']['operating_system'] = node['os']

default['kustomize']['tmp_path'] = Chef::Config['file_cache_path']

# 5.8.1 is the first release that handles the breaking changes helm 4
# introduced, so the helm chart inflator works again (kubernetes-sigs/kustomize#6016).
default['kustomize']['version'] = '5.8.1'
