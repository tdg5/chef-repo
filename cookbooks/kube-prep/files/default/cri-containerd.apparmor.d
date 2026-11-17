# containerd v2.3.4's default container profile (contrib/apparmor/template.go,
# rendered as k3s's containerd renders it on Ubuntu) plus the two stacked-peer
# rules from containerd PR #14487, which fixes containerd issue #14485.
#
# Ubuntu's kernel.apparmor_restrict_unprivileged_unconfined=1 turns runc's
# profile change into a stack, so container processes carry the label
# "cri-containerd.apparmor.d//&unconfined". Since kernel 7.0.0-42 the stock
# profile, which only names "cri-containerd.apparmor.d" as a peer, then denies
# signals between processes of the same container. PostgreSQL's latch wakeups
# (SIGURG) are lost and the instance hangs.
#
# AppArmor loads this file at boot, before k3s starts, and containerd keeps an
# already-loaded profile of this name instead of loading its own. Remove it once
# k3s ships a containerd that includes PR #14487.
abi <abi/3.0>,
#include <tunables/global>

profile cri-containerd.apparmor.d flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>

  network,
  capability,
  file,
  umount,
  # Host (privileged) processes may send signals to container processes.
  signal (receive) peer=unconfined,
  # runc may send signals to container processes.
  signal (receive) peer=runc,
  # crun may send signals to container processes.
  signal (receive) peer=crun,
  # Manager may send signals to container processes.
  signal (receive) peer=unconfined,
  # Container processes may send signals amongst themselves.
  signal (send,receive) peer=cri-containerd.apparmor.d,
  # With kernel.apparmor_restrict_unprivileged_unconfined=1, an unprivileged
  # profile change is converted to stacking, producing
  # "cri-containerd.apparmor.d//&unconfined". Allow that peer as well.
  signal (send,receive) peer=cri-containerd.apparmor.d//&unconfined,

  deny @{PROC}/* w,   # deny write for all files directly in /proc (not in a subdir)
  # deny write to files not in /proc/<number>/** or /proc/sys/**
  deny @{PROC}/{[^1-9/],[^1-9/][^0-9/],[^1-9s/][^0-9y/][^0-9s/],[^1-9/][^0-9/][^0-9/][^0-9/]*}/** w,
  deny @{PROC}/sys/[^k]** w,  # deny /proc/sys except /proc/sys/k* (effectively /proc/sys/kernel)
  deny @{PROC}/sys/kernel/{?,??,[^s][^h][^m]**} w,  # deny everything except shm* in /proc/sys/kernel/
  deny @{PROC}/sysrq-trigger rwklx,
  deny @{PROC}/kcore rwklx,

  deny mount,

  deny /sys/[^f]*/** wklx,
  deny /sys/f[^s]*/** wklx,
  deny /sys/fs/[^c]*/** wklx,
  deny /sys/fs/c[^g]*/** wklx,
  deny /sys/fs/cg[^r]*/** wklx,
  deny /sys/firmware/** rwklx,
  deny /sys/devices/virtual/powercap/** rwklx,
  deny /sys/kernel/security/** rwklx,

  # allow processes within the container to trace each other,
  # provided all other LSM and yama setting allow it.
  ptrace (trace,tracedby,read,readby) peer=cri-containerd.apparmor.d,
  # Same stacked-label peer as the signal rule above.
  ptrace (trace,tracedby,read,readby) peer=cri-containerd.apparmor.d//&unconfined,
}
