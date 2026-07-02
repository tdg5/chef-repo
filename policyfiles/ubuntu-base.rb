name 'ubuntu-base'

default_source :supermarket

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'config', path: '../cookbooks/config'
cookbook 'docker-service', path: '../cookbooks/docker-service'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'liquidprompt', path: '../cookbooks/liquidprompt'
cookbook 'nodejs', '~> 10.1.18', :supermarket
cookbook 'openssh', '~> 2.11.11', :supermarket
cookbook 'python', path: '../cookbooks/python'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'sops', path: '../cookbooks/sops'
cookbook 'terraform', path: '../cookbooks/terraform'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'
cookbook 'vim_wrapper', path: '../cookbooks/vim_wrapper'

run_list(
  'apt',
  'simple-packages::curl',
  'simple-packages::htop',
  'simple-packages::tmux',
  'simple-packages::tree',
  'simple-packages::jq',
  'simple-packages::git-lfs',
  'simple-packages::net-tools',
  'bash_config',
  'config::git',
  'config::sshagent',
  'vim_wrapper',
  'vim_plugins',
  'config::vim',
  'config::tmux',
  'openssh',
  'liquidprompt',
  'nodejs',
  'nodejs::npm',
  'docker-service',
  'python',
  'sops',
  'terraform'
)

default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['nodejs']['binary']['checksum']['linux_x64'] = '783130984963db7ba9cbd01089eaf2c2efb055c7c1693c943174b967b3050cb8'
default['nodejs']['binary']['checksum']['linux_arm64'] = '6b4484c2190274175df9aa8f28e2d758a819cb1c1fe6ab481e2f95b463ab8508'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '24.18.0'
