# Installs a Homebrew cask as the node's user and group.
#
# Chef's core homebrew_cask switches to the brew owner's uid but keeps root's
# gid (0). Homebrew's sandboxed cask extract then runs its Ruby as what looks
# like a setgid process and fails with "no -I allowed while running setgid
# (SecurityError)". Running brew with the user's own group avoids that.
unified_mode true

provides :brew_cask

property :cask_name, String, name_property: true
property :owner, String, default: lazy { node['user']['username'] }
property :group, String, default: lazy { node['user']['group'] }

action :install do
  home = ::Dir.home(new_resource.owner)
  brew = ::File.exist?('/opt/homebrew/bin/brew') ? '/opt/homebrew/bin/brew' : '/usr/local/bin/brew'

  execute "brew install --cask #{new_resource.cask_name}" do
    command "#{brew} install --cask #{new_resource.cask_name}"
    user new_resource.owner
    group new_resource.group
    login true
    cwd home
    environment('HOME' => home, 'USER' => new_resource.owner)
    not_if "#{brew} list --cask #{new_resource.cask_name}"
  end
end
