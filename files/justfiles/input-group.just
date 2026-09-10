# Setup grub in 1080p with 3 second timeout and os prober
add-input-group:
	sudo groupadd --system uinput
	sudo grep -E '^input:' /usr/lib/group >> /etc/group