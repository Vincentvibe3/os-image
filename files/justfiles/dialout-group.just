# Add dialout group to the system
add-dialout-group:
    grep -E '^dialout:' /usr/lib/group | sudo tee -a /etc/group
