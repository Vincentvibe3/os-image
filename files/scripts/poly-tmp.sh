#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

setsebool -P polyinstantiation_enabled 1

# Setup polyinstanced /tmp
# mkdir -p -m 000 /tmp/tmp-inst
# mkdir -p -m 000 /var/tmp/tmp-inst

# chcon --reference /tmp /tmp-inst
# chcon --reference /var/tmp /var/tmp/tmp-inst

# cat /usr/share/ublue-os/poly-tmp/temp-namespace.conf >> /etc/security/namespace.conf
