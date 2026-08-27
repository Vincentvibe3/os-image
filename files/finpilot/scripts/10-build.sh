#!/usr/bin/bash

# Modified from https://github.com/projectbluefin/finpilot/blob/main/build/10-build.sh

set -euo pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -euo pipefail for strict error handling.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
# source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Overlay Brew Integration Files"

# Brew integration files from @ublue-os/brew OCI (tarball, systemd services, shell integration)
rsync -rvK /ctx/oci/brew/ /

echo "::endgroup::"

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/

# Modification to copy only if a file is found due to nullglob
brewfiles=(/ctx/custom/brew/*.Brewfile)
if [[ -v brewfiles ]]; then
    cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/
fi


# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
if [ -f "/ctx/custom/ujust" ]; then
	find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >>/usr/share/ublue-os/just/60-custom.just
fi
# Copy Flatpak preinstall files
# mkdir -p /usr/share/flatpak/preinstall.d/
# cp /ctx/custom/flatpaks/*.preinstall /usr/share/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Packages"

# Install the default packages and verify the DNF cache is working.
# gum is required by the default ujust recipes for interactive prompts.
# dnf5 install -y tmux gum

# Example using COPR with isolated pattern:
# copr_install_isolated "ublue-os/staging" package-name

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
# systemctl enable podman.socket
# systemctl enable brew-setup.service
# systemctl enable brew-update.timer
# systemctl enable brew-upgrade.timer
# Example: systemctl mask unwanted-service

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "Custom build complete!"