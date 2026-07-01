if node['platform_family'] == 'debian'
  include_recipe 'python::deadsnakes'

  # Guard against apt's regex fallback. `apt-get install python3.9` treats the
  # name as a *regex* when no package is named exactly that, so a missing
  # deadsnakes index silently installs an unrelated match (e.g. libcasa-python3-9)
  # instead of failing. Confirm each interpreter package exists as an exact
  # package before we try to install it, and fail loudly with a useful message
  # if it doesn't. `apt-cache policy` pattern-matches too, so we check for the
  # exact `name:` stanza header rather than trusting a non-empty result.
  ruby_block 'verify python packages are available' do
    block do
      missing = node['python']['versions'].reject do |version|
        pkg = "python#{version}"
        shell_out!('apt-cache', 'policy', pkg).stdout.match?(/^#{Regexp.escape(pkg)}:$/)
      end
      unless missing.empty?
        raise "No exact apt package for: #{missing.map { |v| "python#{v}" }.join(', ')}. " \
              "Is the deadsnakes PPA configured and its index fetched for #{node['lsb']['codename']}?"
      end
    end
  end

  node['python']['versions'].each do |version|
    package "python#{version}"
    package "python#{version}-dev"
    package "python#{version}-venv"
  end
elsif node['platform'] == 'mac_os_x'
  node['python']['versions'].each { |version| package "python@#{version}" }
end
