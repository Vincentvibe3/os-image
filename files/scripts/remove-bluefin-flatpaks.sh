set -oue pipefail

# Your code goes here.
# remove bluefin default flatpak list since bluebuild handles our own list
rm -f /usr/share/ublue-os/homebrew/system-flatpaks.Brewfile
