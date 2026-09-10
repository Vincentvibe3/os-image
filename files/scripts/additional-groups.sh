#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

grep -E '^dialout:' /usr/lib/group >> /etc/group
groupadd --system uinput
# grep -E '^uinput:' /usr/lib/group >> /etc/group
grep -E '^input:' /usr/lib/group >> /etc/group