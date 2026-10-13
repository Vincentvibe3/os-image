#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Download userbrew binary and verify integrity
curl -L -o /tmp/userbrew https://github.com/Vincentvibe3/userbrew/releases/latest/download/userbrew
curl -L -o /tmp/userbrew-sha256 https://github.com/Vincentvibe3/userbrew/releases/latest/download/userbrew-sha256
cd /tmp
cksum -a sha2 --length 256 -c userbrew-sha256
cd -

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
systemctl enable userbrew.service

# Copy fuse configuration to enable all users to use the fuse fs
cp /usr/share/ublue-os/userbrew/fuse.conf /etc/fuse.conf