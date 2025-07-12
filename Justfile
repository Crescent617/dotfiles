[private]
default:
    @just --list

# sync repos
sync:
    -cd ./my-busybox && git pull
    -command -v home-manager && cd .config/home-manager && just sync
    -cd /etc/nix-darwin/ && just sync
    -yadm pull

# update system packages
upgrade:
    -command -v brew && brew update && brew upgrade
    -command -v darwin-rebuild && sudo darwin-rebuild switch
    -cd ./services/ && docker compose pull
    -command -v nixos-rebuild && sudo nixos-rebuild switch --upgrade

[macos]
update-mihomo-sub:
    mihomo.py update_sub
    sudo launchctl kickstart -k system/org.nixos.mihomo
