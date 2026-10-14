# Fix cjk rendering on a flatpak app
# based on https://github.com/Blackmesa-Canteen/flatpak-cjk-font-fix
fix-flatpak-cjk:
    #!/usr/bin/env bash
    set -euo pipefail
    installed_apps=$(flatpak list --app --columns=application | sort -u)
    app_id=$(gum filter --limit 1 --header "What should be fixed" $installed_apps)
    if [[ $app_id != "" ]]; then
    	mkdir -p ~/.var/app/$app_id/config/fontconfig/conf.d/
    	touch ~/.var/app/$app_id/config/fontconfig/conf.d/99-flatpak-cjk-host-fonts.conf
    	cat > ~/.var/app/$app_id/config/fontconfig/conf.d/99-flatpak-cjk-host-fonts.conf <<- EOF
    		<?xml version="1.0"?>
    		<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    		<fontconfig>
    			<dir>/run/host/fonts</dir>
    			<dir>/run/host/local-fonts</dir>
    			<dir>/run/host/user-fonts</dir>
    		</fontconfig>
    	EOF
    fi

# Remove cjk host font cache fix
# based on https://github.com/Blackmesa-Canteen/flatpak-cjk-font-fix
remove-flatpak-cjk:
    #!/usr/bin/env bash
    set -euo pipefail
    installed_apps=$(flatpak list --app --columns=application | sort -u)
    app_id=$(gum filter --limit 1 --header "What should be restored" $installed_apps)
    if [[ $app_id != "" ]]; then
    	rm -f ~/.var/app/$app_id/config/fontconfig/conf.d/99-flatpak-cjk-host-fonts.conf
    fi
