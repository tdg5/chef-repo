# Postgres client tools (psql, pg_dump, ...). Homebrew's libpq is keg-only, so
# its bin directory must be added to PATH to use them.
if platform?('mac_os_x')
  package 'libpq'
end
