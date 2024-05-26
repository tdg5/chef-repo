name 'macos-base'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'chrome', path: '../cookbooks/chrome'
cookbook 'config', path: '../cookbooks/config'
cookbook 'docker-service', path: '../cookbooks/docker-service'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'homebrew', '~> 5.4.8', :supermarket
cookbook 'macos-packages', path: '../cookbooks/macos-packages'
cookbook 'python', path: '../cookbooks/python'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'slack', path: '../cookbooks/slack'
cookbook 'skype', path: '../cookbooks/skype'
cookbook 'sops', path: '../cookbooks/sops'
cookbook 'spotify', path: '../cookbooks/spotify'
cookbook 'terraform', path: '../cookbooks/terraform'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'
cookbook 'vim_wrapper', path: '../cookbooks/vim_wrapper'

run_list(
  'homebrew',
  'config::zsh',
  'config::git',
  'bash_config',
  'simple-packages::htop',
  'simple-packages::tmux',
  'simple-packages::tree',
  'simple-packages::jq',
  'simple-packages::git-lfs',
  'simple-packages::xsel',
  'simple-packages::jhead',
  'simple-packages::multipass',
  'simple-packages::vlc',
  'simple-packages::gimp',
  'vim_wrapper',
  'config::tmux',
  'config::vim',
  'vim_plugins',
  'docker-service',
  'python',
  'spotify',
  'sops',
  'terraform',
  'slack',
  'skype',
  'chrome',
  'macos-packages::android-file-transfer',
)
