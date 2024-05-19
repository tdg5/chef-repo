name 'macos-base'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'config', path: '../cookbooks/config'
cookbook 'docker-service', path: '../cookbooks/docker-service'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'homebrew', '~> 5.4.8', :supermarket
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'

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
  'config::tmux',
  'config::vim',
  'config::zsh',
  'config::git',
  'bash_config',
  'vim_plugins',
  'docker-service',
)
