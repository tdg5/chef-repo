# Arguments passed to earlyoom via /etc/default/earlyoom:
# - report memory every hour (-r 3600)
# - act when available memory drops below 5% (-m 5)
# - send desktop notifications (-n)
# - kill TypeScript/Node dev processes first, and spare databases, agents,
#   terminal sessions and core system daemons
#
# systemd word-splits $EARLYOOM_ARGS without interpreting quotes, so the
# regexes below must not contain spaces or quotes.
default['earlyoom']['args'] = [
  '-r 3600',
  '-m 5',
  '-n',
  '--prefer ^(tsc|node|next-server)$',
  '--avoid ^(postgres|claude|tmux:.*|sshd|systemd|dockerd|containerd)$',
]
