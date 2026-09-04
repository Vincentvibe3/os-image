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
fi