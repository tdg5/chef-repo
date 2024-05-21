name 'kubernetes-client'

default_source :supermarket

cookbook 'helm', path: '../cookbooks/helm'
cookbook 'kubectl', path: '../cookbooks/kubectl'
cookbook 'kustomize', path: '../cookbooks/kustomize'

run_list(
  'kubectl',
  'kustomize',
  'helm',
)
