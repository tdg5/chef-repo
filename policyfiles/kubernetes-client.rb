name 'kubernetes-client'

default_source :supermarket

cookbook 'helm', path: '../cookbooks/helm'
cookbook 'kubectl', path: '../cookbooks/kubectl'

run_list(
  'helm',
  'kubectl',
)
