name 'kubernetes-client'

default_source :supermarket

cookbook 'argocd', path: '../cookbooks/argocd'
cookbook 'helm', path: '../cookbooks/helm'
cookbook 'kargo', path: '../cookbooks/kargo'
cookbook 'ksops', path: '../cookbooks/ksops'
cookbook 'kubectl', path: '../cookbooks/kubectl'
cookbook 'kustomize', path: '../cookbooks/kustomize'
cookbook 'minikube', path: '../cookbooks/minikube'
cookbook 'sops', path: '../cookbooks/sops'

run_list(
  'kubectl',
  'kustomize',
  'helm',
  'helm::v3',
  'sops',
  'ksops',
  'argocd',
  'kargo',
  'minikube'
)
