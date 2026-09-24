#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# remove system wide homebrew setup from ublue-os/brew
systemctl disable brew-setup.service
systemctl disable brew-update.timer
systemctl disable brew-upgrade.timer
rm /usr/lib/systemd/system-preset/01-homebrew.preset
rm /usr/lib/systemd/system/brew-setup.service
rm /usr/lib/systemd/system/brew-update.service
rm /usr/lib/systemd/system/brew-update.timer
rm /usr/lib/systemd/system/brew-upgrade.service
rm /usr/lib/systemd/system/brew-upgrade.timer

# Add modified units to user directory and polyinstantiation creation unit
cp -r -n /usr/share/ublue-os/userbrew/systemd/. /usr/lib/systemd/
ls /usr/lib/systemd/user-preset
systemctl --global preset brew-setup.service
systemctl --global preset brew-update.timer
systemctl --global preset brew-upgrade.timer
systemctl enable brew-generate-folder.service

# pam_namespace_helper ignores namespace.d so merge to main config
cat /usr/share/ublue-os/userbrew/brew-namespace.conf >> /etc/security/namespace.conf
cp /usr/share/ublue-os/userbrew/userbrew.init /etc/security/namespace.d/userbrew.init
chmod +x /etc/security/namespace.d/userbrew.init

# Set selinux rules to allow execution of binaries in userbrew.init
# otherwise the directories cant be chowned
semodule -i /usr/share/ublue-os/userbrew/userbrew.pp
semodule -i /usr/share/ublue-os/userbrew/userbrew_transitive.pp
semodule -i /usr/share/ublue-os/userbrew/userbrew_map.pp