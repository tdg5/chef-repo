if platform_family?('debian')
  # GitHub ships gh from its own apt repository. The repo uses a fixed `stable`
  # distribution (not the host's lsb codename) and only publishes amd64/arm64
  # packages, so the arch is pinned to avoid apt fetching absent i386 metadata.
  apt_repository 'github-cli' do
    arch node['github-cli']['architecture']
    components ['main']
    distribution 'stable'
    key 'https://cli.github.com/packages/githubcli-archive-keyring.gpg'
    uri 'https://cli.github.com/packages'
  end
end

package 'gh'
