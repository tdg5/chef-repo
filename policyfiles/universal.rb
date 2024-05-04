name 'universal'

default_source :supermarket

cookbook 'apt', '~> 7.5.17', :supermarket
cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'chrome', path: '../cookbooks/chrome'
cookbook 'config', path: '../cookbooks/config'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'openssh',  '~> 2.11.11', :supermarket
cookbook 'simple_packages', path: '../cookbooks/simple_packages'
cookbook 'vim', '~> 2.1.20', :supermarket
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'

run_list(
  'apt',
  'simple_packages::htop',
  'simple_packages::tmux',
  'simple_packages::wmctrl',
  'simple_packages::xsel',
  'bash_config',
  'config::git',
  'config::sshagent',
  'vim',
  'vim_plugins',
  'config::vim',
  'config::tmux',
  'openssh',
  'chrome',
  'simple_packages::nautilus-dropbox',
  'liquidprompt',
)

default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
