# Regenerate grub, only do this if user.cfg cannot be used
# For example to run os-prober
grub-config:
    sudo grub2-mkconfig -o /etc/grub2.cfg
    sudo grub2-mkconfig -o /etc/grub2-efi.cfg
