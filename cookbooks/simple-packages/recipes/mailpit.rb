# Mailpit, a local SMTP server that catches outgoing mail and shows it in a web
# UI. It is only installed, not started; run `mailpit` when you need it.
if platform?('mac_os_x')
  package 'mailpit'
elsif platform?('ubuntu')
  # Not in Ubuntu's archive, so install the release binary from GitHub.
  version = 'v1.33.1'
  checksums = {
    'amd64' => '84d7fe375ebef25df26758984dc0d5d5e17d8c0734cb2e77be7873b14ab51716',
    'arm64' => '3c5f076cb676d6980e47da030861c6d60f1f5614103dea93cccbcdfc43198e12',
  }
  arch = node['kernel']['machine'] == 'aarch64' ? 'arm64' : 'amd64'
  tarball = ::File.join(Chef::Config[:file_cache_path], "mailpit-#{version}-linux-#{arch}.tar.gz")
  install_directory = "/opt/mailpit/#{version}"

  remote_file tarball do
    checksum checksums[arch]
    source "https://github.com/axllent/mailpit/releases/download/#{version}/mailpit-linux-#{arch}.tar.gz"
  end

  archive_file tarball do
    destination install_directory
  end

  link '/usr/local/bin/mailpit' do
    to ::File.join(install_directory, 'mailpit')
  end
end
