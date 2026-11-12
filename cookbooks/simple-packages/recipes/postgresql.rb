# A local Postgres 18 server with the pgvector extension. Homebrew's
# postgresql@18 is keg-only; start it with `brew services start postgresql@18`.
if platform?('mac_os_x')
  package 'postgresql@18'
  package 'pgvector'
end
