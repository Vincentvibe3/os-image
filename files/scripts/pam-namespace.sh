#!/usr/bin/env bash

set -oue pipefail

if [[ ! -f /etc/.pam_namespaced ]]; then

	touch /etc/.pam_namespaced

	# Setup selinux
	setsebool -P allow_polyinstantiation 1

	# Create a vendor override for local
	cp -r /usr/share/authselect/default/local/ /usr/share/authselect/vendor/local/

	# Add pam namespaces
	cat >> /usr/share/authselect/vendor/local/system-auth <<- EOF
	session         required        pam_namespace.so unmnt_remnt ignore_config_error {include if "with-namespace"}
	EOF

	# generate pam files
	authselect select local
	authselect enable-feature "with-namespace"
	authselect apply-changes 

	# Adjust other pam files
	sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/login
	sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/sshd
	sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' /etc/pam.d/remote
	echo "session     required      pam_namespace.so unmnt_remnt ignore_config_error debug" >> /etc/pam.d/su

	for gdmfile in $(ls /etc/pam.d/gdm*); do
		if [ $(grep -c "session    required    pam_namespace.so unmnt_remnt ignore_config_error debug" $gdmfile) -eq 0 ]; then
			sed -i 's/^.*pam_namespace.so$/session     required      pam_namespace.so unmnt_remnt ignore_config_error debug/' $gdmfile
		fi
	done
fi