# --- crackbook (2016 MacBookPro13,1 -> cerberus k3s light worker) -------------
# Host-specific tuning consumed by recipes/crackbook.rb. Defaults are the
# expected values for that machine; override per-node in the policyfile. These
# attributes are namespaced and unused by other node-specific recipes (e.g.
# ::gal), so defining them globally here is harmless.

# Realtek RTL8153 USB gigabit adapter -- the node's ONLY NIC (in-kernel r8152
# driver). Pinned out of USB autosuspend (see recipes/crackbook.rb) so
# `powertop --auto-tune` never powers it down, which would drop the node to
# NotReady. Confirmed on the box via `lsusb` (0bda:8153). The rule matches by
# id, so the driver name is irrelevant.
default['crackbook']['usb_nic']['id_vendor'] = '0bda'
default['crackbook']['usb_nic']['id_product'] = '8153'

# Broadcom Wi-Fi/BT kernel modules we deliberately do NOT use (wired-ethernet-
# only node) -- blacklisted so they never load.
default['crackbook']['blacklist_modules'] = %w[ brcmfmac brcmfmac_wcc b43 wl btusb ]

# consoleblank timeout (seconds) appended to the kernel cmdline; blanks the
# internal panel since the box runs clamshell (lid closed).
default['crackbook']['consoleblank'] = 60
