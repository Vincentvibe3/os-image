# Add input and uinput groups to the system
add-input-group:
    sudo groupadd -f --system uinput
    grep -E '^input:' /usr/lib/group | sudo tee -a /etc/group
