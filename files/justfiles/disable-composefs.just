# Disable composefs
disable-composefs:
    sudo rpm-ostree kargs --append=ostree.prepare-root.composefs=0
