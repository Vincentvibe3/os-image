# Enroll fido key to disk
enroll-fido-luks:
    #!/usr/bin/env bash
    shopt -s nullglob
    disks=$(ls /dev/nvme* /dev/sda*)
    luks_device=$(gum choose $disks)
    sudo systemd-cryptenroll --fido2-device=auto $luks_device
