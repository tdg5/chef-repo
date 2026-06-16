# Node-specific host prep for `crackbook` -- a 2016 13" MacBook Pro
# (MacBookPro13,1) run headless, clamshell (lid closed), AC-powered, as a
# light/best-effort k3s agent on cerberus. This is the idempotent form of
# plan-2016-macbook-to-k8s.md "Phase 2 -- Host prep". The k3s join + node-token
# stay manual; the k3s-agent cookbook owns only the declarative node config.

root_username = node['root_user']['username']
root_group = node['root_user']['group']

# --- Clamshell: never suspend on lid close ------------------------------------
# Without this the node sleeps the moment the lid shuts. Written as a logind
# drop-in (systemd's recommended override) rather than rewriting the shipped
# logind.conf. All three states are covered so it holds on AC, on battery (the
# pack was left in this build), and "docked".
directory '/etc/systemd/logind.conf.d' do
  mode '0755'
  owner root_username
  group root_group
end

file '/etc/systemd/logind.conf.d/10-crackbook-lid.conf' do
  content <<~CONF
    # Managed by Chef (node-specific::crackbook). Clamshell operation: ignore
    # the lid switch so closing the lid never suspends this headless node.
    [Login]
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  CONF
  mode '0644'
  owner root_username
  group root_group
  notifies :restart, 'service[systemd-logind]', :delayed
end

service 'systemd-logind' do
  action :nothing
end

# --- Disable radios: wired-ethernet-only, Broadcom Wi-Fi/BT unused ------------
# Takes effect on the next boot / module reload. We use the USB ethernet adapter
# exclusively; the Broadcom Wi-Fi/BT need proprietary firmware and are ignored.
file '/etc/modprobe.d/crackbook-blacklist-radios.conf' do
  content "# Managed by Chef (node-specific::crackbook). Wired-ethernet-only node.\n" +
          node['crackbook']['blacklist_modules'].map { |m| "blacklist #{m}" }.join("\n") + "\n"
  mode '0644'
  owner root_username
  group root_group
end

# --- Fan + temperature sensors (matters in clamshell -- a closed lid traps
# heat) ------------------------------------------------------------------------
# Under Linux the SMC fan curve is not managed, so install mbpfan to drive the
# fans. mbpfan acts on the Intel CPU temps from `coretemp`; `applesmc` exposes
# the Apple SMC fans and board sensors. lm-sensors provides the `sensors` CLI
# for spot checks. Load both modules on boot and now.
sensor_modules = %w[ coretemp applesmc ]

file '/etc/modules-load.d/crackbook-sensors.conf' do
  content "# Managed by Chef (node-specific::crackbook).\n" +
          sensor_modules.join("\n") + "\n"
  mode '0644'
  owner root_username
  group root_group
end

# Remove the earlier applesmc-only file, superseded by crackbook-sensors.conf
# above (idempotent no-op once gone).
file '/etc/modules-load.d/applesmc.conf' do
  action :delete
end

sensor_modules.each do |mod|
  execute "modprobe #{mod}" do
    not_if "lsmod | grep -q '^#{mod}\\b'"
  end
end

package %w[ lm-sensors mbpfan ]

service 'mbpfan' do
  action [:enable, :start]
end

# --- USB ethernet: exempt from autosuspend ------------------------------------
# The Realtek RTL8153 USB adapter is the only NIC. powertop --auto-tune (below)
# would set its power/control to `auto` and the adapter can autosuspend ->
# NotReady node. Pin it `on` via udev, matched by id (driver-agnostic). The boot
# oneshot re-triggers udev AFTER powertop so this rule wins.
nic = node['crackbook']['usb_nic']
file '/etc/udev/rules.d/80-crackbook-usb-nic-nosuspend.rules' do
  content <<~RULE
    # Managed by Chef (node-specific::crackbook). Keep the Realtek RTL8153 USB
    # ethernet adapter (the node's only NIC) out of USB autosuspend.
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="#{nic['id_vendor']}", ATTR{idProduct}=="#{nic['id_product']}", ATTR{power/control}="on"
  RULE
  mode '0644'
  owner root_username
  group root_group
  notifies :run, 'execute[crackbook reload udev]', :immediately
end

execute 'crackbook reload udev' do
  command 'udevadm control --reload && udevadm trigger --subsystem-match=usb --action=add'
  action :nothing
end

# --- Console blanking via kernel cmdline --------------------------------------
# Blank the internal panel; the box runs clamshell so the screen is unused.
# Ubuntu sources /etc/default/grub.d/*.cfg from /etc/default/grub.
file '/etc/default/grub.d/99-crackbook.cfg' do
  content %(# Managed by Chef (node-specific::crackbook).\n) +
          %(GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT consoleblank=#{node['crackbook']['consoleblank']}"\n)
  mode '0644'
  owner root_username
  group root_group
  notifies :run, 'execute[crackbook update-grub]', :immediately
end

execute 'crackbook update-grub' do
  command 'update-grub'
  action :nothing
end

# --- Boot-time power tuning ----------------------------------------------------
# One-shot at boot: CPU governor, backlight off, then powertop --auto-tune, then
# a udev re-trigger so the NIC autosuspend exemption is re-asserted AFTER
# powertop clobbers it. Ordering is the whole point -- see the inline note.
package 'powertop'

file '/usr/local/sbin/crackbook-power-tuning.sh' do
  content <<~'SH'
    #!/usr/bin/env bash
    # Managed by Chef (node-specific::crackbook). One-shot power tuning at boot.
    set -u

    # CPU: powersave governor. On intel_pstate this is the dynamic default, but
    # set it explicitly. Skylake-U idles to a couple of watts with deep C-states.
    for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
      [ -w "$g" ] && echo powersave > "$g" || true
    done

    # Blank the internal panel / kill backlight (clamshell -- screen unused).
    for bl in /sys/class/backlight/*; do
      [ -w "$bl/bl_power" ]   && echo 4 > "$bl/bl_power"   || true
      [ -w "$bl/brightness" ] && echo 0 > "$bl/brightness" || true
    done

    # USB autosuspend, PCIe ASPM, SATA/NVMe ALPM, audio power-down, etc.
    command -v powertop >/dev/null 2>&1 && powertop --auto-tune || true

    # Re-assert the udev rules powertop just clobbered -- specifically the
    # ethernet adapter's power/control=on. Without this the ONLY NIC can
    # autosuspend and the node goes NotReady.
    udevadm trigger --subsystem-match=usb --action=add || true
  SH
  mode '0755'
  owner root_username
  group root_group
end

file '/etc/systemd/system/crackbook-power-tuning.service' do
  content <<~UNIT
    # Managed by Chef (node-specific::crackbook).
    [Unit]
    Description=crackbook one-shot power tuning (governor, backlight, powertop)
    After=multi-user.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/local/sbin/crackbook-power-tuning.sh

    [Install]
    WantedBy=multi-user.target
  UNIT
  mode '0644'
  owner root_username
  group root_group
  notifies :run, 'execute[crackbook daemon-reload]', :immediately
end

execute 'crackbook daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

service 'crackbook-power-tuning' do
  action [:enable, :start]
end
