user_home_directory = node['user']['home_directory']
username = node['user']['username']
user_group = node['user']['group']

[
  File.join(user_home_directory, node['vim_plugins']['user_vim_config_dir']),
  File.join(user_home_directory, node['vim_plugins']['user_autoload_dir']),
  File.join(user_home_directory, node['vim_plugins']['user_bundle_dir']),
].each do |dir|
  directory dir do
    group user_group
    mode '0755'
    owner username
    recursive true
  end
end

include_recipe 'vim_plugins::pathogen'
include_recipe 'vim_plugins::matchit'
include_recipe 'vim_plugins::vim_ruby'
include_recipe 'vim_plugins::vim_rake'
include_recipe 'vim_plugins::vim_bundler'
include_recipe 'vim_plugins::vim_rails'
include_recipe 'vim_plugins::nerdcommenter'
include_recipe 'vim_plugins::ctrlp'
include_recipe 'vim_plugins::vim_fugitive'
include_recipe 'vim_plugins::vim_repeat'
include_recipe 'vim_plugins::vim_surround'
include_recipe 'vim_plugins::easymotion'
include_recipe 'vim_plugins::tagbar'
include_recipe 'vim_plugins::git_gutter'
include_recipe 'vim_plugins::vim_json'
include_recipe 'vim_plugins::mlessnau_block_shift'
include_recipe 'vim_plugins::colorschemes'
include_recipe 'vim_plugins::vim_trailing_whitespace'
include_recipe 'vim_plugins::vim_obsession'
include_recipe 'vim_plugins::markdown'
include_recipe 'vim_plugins::vim_go'
include_recipe 'vim_plugins::vim_endwise'
include_recipe 'vim_plugins::you_complete_me'
include_recipe 'vim_plugins::python_indent'
include_recipe 'vim_plugins::terraform'
