name 'kubernetes-client'

default_source :supermarket

cookbook 'argocd', path: '../cookbooks/argocd'
cookbook 'helm', path: '../cookbooks/helm'
cookbook 'ksops', path: '../cookbooks/ksops'
cookbook 'kubectl', path: '../cookbooks/kubectl'
cookbook 'kustomize', path: '../cookbooks/kustomize'
cookbook 'sops', path: '../cookbooks/sops'

run_list(
  'kubectl',
  'kustomize',
  'helm',
  'sops',
  'ksops',
  'argocd',
)
