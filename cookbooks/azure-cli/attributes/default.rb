# Microsoft's azure-cli apt repo only publishes select (mostly LTS) suites --
# see https://packages.microsoft.com/repos/azure-cli/dists/. Interim/newer
# Ubuntu releases (e.g. resolute / 26.04) have no suite there, so `apt-get
# update` 404s on the Release file. Use the running codename when Microsoft
# builds for it; otherwise fall back to the newest supported suite (Microsoft's
# recommended approach for unsupported releases). Override to pin explicitly.
supported_suites = %w(noble jammy focal)
default['azure-cli']['distribution'] = (
  if supported_suites.include?(node['lsb']['codename'])
    node['lsb']['codename']
  else
    'noble'
  end
)
