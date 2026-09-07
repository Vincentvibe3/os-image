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
mkdir -p /var/home/linuxbrew/
mkdir -p /var/home/linuxbrew/.userbrew
chmod 000 /var/home/linuxbrew/.userbrew

# allow selinux
setsebool -P polyinstantiation_enabled 1

# systemctl enable brew-folders-setup.service
for gdmfile in $(ls /etc/pam.d/gdm*); do
	if [ $(grep -c "session    required    pam_namespace.so unmnt_remnt ignore_config_error debug" $gdmfile) -eq 0 ]; then
		sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' $gdmfile
		# sed -i 's/session    required    pam_namespace.so//' $gdmfile
	fi
done

sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/login
sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/sshd
sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/remote

# pam_namespace_helper ignores namespace.d so merge to main config
cat /usr/share/ublue-os/userbrew/brew-namespace.conf >> /etc/security/namespace.conf
cp /usr/share/ublue-os/userbrew/userbrew.init /etc/security/namespace.d/userbrew.init
chmod +x /etc/security/namespace.d/userbrew.init

