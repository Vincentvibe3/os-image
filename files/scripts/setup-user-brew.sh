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

# Add modified units to user directory

# Create folder for polyinstanced brew instances
# mkdir -p -m 000 /var/home/.user-brew
# mkdir -p -m 000 /home/.user-brew

# pam_namespace_helper ignores namespace.d so merge to main config
cat /usr/share/ublue-os/namespaces/brew-namespace.conf >> /etc/security/namespace.conf
