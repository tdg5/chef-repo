name 'universal'

default_source :supermarket

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'chrome', path: '../cookbooks/chrome'
cookbook 'config', path: '../cookbooks/config'
cookbook 'docker-service', path: '../cookbooks/docker-service'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'liquidprompt', path: '../cookbooks/liquidprompt'
cookbook 'nodejs', '~> 10.1.18', :supermarket
cookbook 'openssh',  '~> 2.11.11', :supermarket
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'vim', '~> 2.1.20', :supermarket
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'

run_list(
  'apt',
  'simple-packages::curl',
  'simple-packages::htop',
  'simple-packages::tmux',
  'simple-packages::tree',
  'simple-packages::wmctrl',
  'simple-packages::xsel',
  'simple-packages::gimp',
  'simple-packages::jhead',
  'bash_config',
  'config::git',
  'config::sshagent',
  'vim',
  'vim_plugins',
  'config::vim',
  'config::tmux',
  'openssh',
  'chrome',
  'config::mime_applications',
  'simple-packages::nautilus-dropbox',
  'liquidprompt',
  'nodejs',
  'nodejs::npm',
  'docker-service',
)

default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['nodejs']['binary']['checksum'] = '8c9f4c95c254336fcb2c768e746f4316b8176adc0fb599cbbb460d0933991d12'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '22.1.0'
