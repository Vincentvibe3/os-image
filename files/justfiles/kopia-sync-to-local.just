# Sync a kopia repo to another local location
kopia-sync:
    #!/usr/bin/env bash
    detected_repos=$(ls ~/.config/kopia/*.config)
    kopia_repo_choice=$(gum choose --header "Choose a repository to sync from" $detected_repos "other")

    if [[ $kopia_repo_choice == "other" ]]; then
        kopia_repo_choice=$(gum input --header "Input the path to the repo to sync from" --header.foreground 212)
    fi

    if [[ $kopia_repo_choice != "" ]]; then
        kopia_dest_choice=$( gum input --header "Input the path to the repo to sync to" --header.foreground 212)
        if [[ $kopia_dest_choice != "" ]]; then
            gum spin --show-output --show-error --spinner dot --title '' -- kopia repository --config-file="$kopia_repo_choice" sync-to filesystem --path "$kopia_dest_choice" --must-exist
        fi
    fi