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
cp -r -n /usr/share/ublue-os/userbrew/systemd/. /usr/lib/systemd/
ls /usr/lib/systemd/user-preset
systemctl --global preset brew-setup.service
systemctl --global preset brew-update.timer
systemctl --global preset brew-upgrade.timer

# Create folder for polyinstanced brew instances
# mkdir -p -m 775 /var/home/.user-brew
mkdir -p -m 000 /var/home/.user-brew
mkdir -p /var/home/linuxbrew/

# Copy user brew directory generator
# This is needed to create them before gdm does (gdm has errors otherwise)

# mkdir -p /usr/libexec/user-brew/
# cp /usr/share/ublue-os/userbrew/generate-brew-dirs.py /usr/libexec/user-brew/generate-brew-dirs
# chmod +x /usr/libexec/user-brew/generate-brew-dirs
# cp /usr/share/ublue-os/userbrew/brew-folders-setup.service /etc/systemd/system
# systemctl enable brew-folders-setup.service
for gdmfile in $(ls /etc/pam.d/gdm*); do
	if [ $(grep -c "session    required    pam_namespace.so unmnt_remnt ignore_config_error debug" $gdmfile) -ne 0 ]; then
		sed -i 's/session    required    pam_namespace.so/session    required    pam_namespace.so unmnt_remnt ignore_config_error debug/' $gdmfile
	fi
done
# pam_namespace_helper ignores namespace.d so merge to main config
cat /usr/share/ublue-os/userbrew/brew-namespace.conf >> /etc/security/namespace.conf
# cp /usr/share/ublue-os/userbrew/userbrew-namespace.init /etc/security/namespace.d/userbrew-namespace.init
# chmod +x /etc/security/namespace.d/userbrew-namespace.init

# sed -i 's/exit 0//' /etc/security/namespace.init

# cat >> /etc/security/namespace.init <<- EOF

# if [ -f "/etc/security/namespace.d/userbrew-namespace.init" ]; then
# 	/etc/security/namespace.d/userbrew-namespace.init $@
# else
# 	if [ -f "/usr/etc/security/namespace.d/userbrew-namespace.init" ]; then
# 		/usr/etc/security/namespace.d/userbrew-namespace.init $@
# 	fi
# fi
# exit 0

# EOF
