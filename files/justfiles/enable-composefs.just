# Enable composefs
enable-composefs:
    sudo rpm-ostree kargs --delete-if-present=ostree.prepare-root.composefs=0
