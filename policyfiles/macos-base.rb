name 'macos-base'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'config', path: '../cookbooks/config'
cookbook 'docker-service', path: '../cookbooks/docker-service'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'homebrew', '~> 5.4.8', :supermarket
cookbook 'python', path: '../cookbooks/python'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'sops', path: '../cookbooks/sops'
cookbook 'spotify', path: '../cookbooks/spotify'
cookbook 'terraform', path: '../cookbooks/terraform'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'
cookbook 'vim_wrapper', path: '../cookbooks/vim_wrapper'

run_list(
  'homebrew',
  'simple-packages::htop',
  'simple-packages::tmux',
  'simple-packages::tree',
  'simple-packages::xsel',
  'simple-packages::jhead',
  'simple-packages::multipass',
  'simple-packages::vlc',
  'simple-packages::gimp',
  'vim_wrapper',
  'config::tmux',
  'config::vim',
  'config::zsh',
  'config::git',
  'bash_config',
  'vim_plugins',
  'docker-service',
  'python',
  'spotify',
  'sops',
  'terraform',
)
