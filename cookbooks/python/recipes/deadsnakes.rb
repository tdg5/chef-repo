# Add the deadsnakes PPA explicitly instead of via the `ppa:apt_repository`
# shortcut.
#
# The shortcut has two failure modes we hit in practice:
#   1. It calls the launchpad.net API at converge time to discover the signing
#      key, so a converge fails whenever launchpad.net itself is unreachable
#      (its IPv4 is flaky from some networks) even though the package/key hosts
#      are fine.
#   2. On recent gnupg it installs the key as a GPG *keybox* database, which
#      apt's `signed-by=` rejects as an "unsupported filetype" -- the repo is
#      then treated as unsigned and its entire index is discarded.
#
# Instead we ship the signing key with the cookbook, dearmor it ourselves into
# the plain binary keyring apt expects, and point the repo at that file. No
# launchpad.net API call, and a deterministic key format.
if platform_family?('debian')
  keyring     = '/etc/apt/keyrings/deadsnakes.gpg'
  armored_key = '/etc/apt/keyrings/deadsnakes.asc'

  directory '/etc/apt/keyrings' do
    owner 'root'
    group 'root'
    mode  '0755'
  end

  cookbook_file armored_key do
    source 'deadsnakes.asc'
    owner  'root'
    group  'root'
    mode   '0644'
    notifies :run, 'execute[dearmor deadsnakes key]', :immediately
  end

  # gpg --dearmor is deterministic, so this only needs to run when the shipped
  # key changes (or on first install, when the cookbook_file above is created).
  execute 'dearmor deadsnakes key' do
    command "gpg --batch --yes --dearmor -o #{keyring} #{armored_key}"
    action :nothing
  end

  # `distribution` intentionally omitted: apt_repository defaults it to the
  # node's own codename (node['lsb']['codename']), which is what we want.
  # `key` is intentionally left at its default: we manage the keyring ourselves
  # via `signed_by`, so no key fetching/import by the resource (a non-ppa `uri`
  # plus non-empty `components` also keeps it from touching the launchpad API).
  apt_repository 'deadsnakes' do
    uri        'https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu'
    components %w(main)
    signed_by  keyring
  end
end
