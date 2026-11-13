# A local Postgres 18 server with the pgvector extension. Homebrew's
# postgresql@18 is keg-only; start it with `brew services start postgresql@18`.
# On Ubuntu the server runs as the postgresql service as soon as it's installed.
if platform?('mac_os_x')
  package 'postgresql@18'
  package 'pgvector'
elsif platform?('ubuntu')
  package %w(postgresql-18 postgresql-18-pgvector)
end
