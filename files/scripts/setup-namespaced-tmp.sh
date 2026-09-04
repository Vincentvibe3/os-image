#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Setup polyinstanced /tmp
# mkdir -m 000 /tmp-inst
# mkdir -m 000 /var/tmp/tmp-inst

# chcon --reference /tmp /tmp-inst
# chcon --reference /var/tmp /var/tmp/tmp-inst

cat /usr/share/ublue-os/namespaces/temp-namespace.conf >> /etc/security/namespace.conf