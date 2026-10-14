# Clear font cache to fix vscode font issues
clear-font-cache:
	rm -rf ~/.cache/fontconfig/ && rm -rf ~/.config/fontconfig && fc-cache -rv