# Claude Code ships a native installer that downloads a per-user binary into
# ~/.local/bin and self-updates thereafter, so it is installed as the target
# user rather than system-wide.
default['claude-code']['install_script_url'] = 'https://claude.ai/install.sh'

# Version target passed to the installer: 'stable', 'latest', or a specific
# version like '1.0.58'.
default['claude-code']['version'] = 'stable'

default['claude-code']['install']['username'] = node['user']['username']
default['claude-code']['install']['group'] = node['user']['group']
default['claude-code']['install']['home_directory'] = node['user']['home_directory']
