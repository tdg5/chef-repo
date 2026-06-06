name 'zendesk'

default_source :supermarket

cookbook 'bash_config', path: '../cookbooks/bash_config'
cookbook 'cluster-storage', path: '../cookbooks/cluster-storage'
cookbook 'config', path: '../cookbooks/config'
cookbook 'exuberant-ctags', path: '../cookbooks/exuberant-ctags'
cookbook 'liquidprompt', path: '../cookbooks/liquidprompt'
cookbook 'simple-packages', path: '../cookbooks/simple-packages'
cookbook 'swap', path: '../cookbooks/swap'
cookbook 'ufw', path: '../cookbooks/ufw'
cookbook 'vim_plugins', path: '../cookbooks/vim_plugins'
cookbook 'vim_wrapper', path: '../cookbooks/vim_wrapper'

run_list(
  # Standard interactive shell environment (subset of ubuntu-base; no
  # docker/desktop, server-safe on 26.04).
  'bash_config',
  'config::git',
  'config::sshagent',
  'vim_wrapper',
  'vim_plugins',
  'config::vim',
  'config::tmux',
  'liquidprompt',
  # Host infrastructure (this session's work).
  'swap::disable',
  'ufw',
  'cluster-storage',
)

username = 'tdg5'
group = username

default['user'] = {
  email: 'dannyguinther@gmail.com',
  group: group,
  home_directory: '/home/tdg5',
  username: username,
}

default['root_user'] = {
  group: 'root',
  username: 'root',
}

# Bulk-storage HDD relocated from proxima (4 TB Seagate ST4000DM000). These are
# node-specific identifiers consumed by the cluster-storage cookbook.
default['cluster_storage']['disk']['by_id'] = 'ata-ST4000DM000-1F2168_W3002BF7'
default['cluster_storage']['uuid'] = '0adb1308-714a-4af6-980a-e7b7f22df022'

# Files sourced from the generated ~/.bashrc. The template guards each with
# `[ -e <path> ]`, so entries whose file is absent are simply skipped.
default['bash']['bashrc']['extra_sources']['standard bash aliases'] = '~/.bash_aliases'
default['bash']['bashrc']['extra_sources']['extra, env dependent aliases'] = '~/.bash/extra_aliases'
default['bash']['bashrc']['extra_sources']['liquidprompt'] = '/opt/liquidprompt/liquidprompt'
default['bash']['bashrc']['extra_sources']['ssh agent'] = '~/.sshagentrc'
