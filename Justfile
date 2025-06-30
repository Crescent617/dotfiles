[private]
default:
    @just --list

sync:
    -cd ./my-busybox && git pull
    -command -v home-manager && cd .config/home-manager && just sync
    -yadm pull

upgrade:
    -command -v brew && brew update && brew upgrade
    -command -v darwin-rebuild && sudo darwin-rebuild switch

[macos]
update-mihomo-sub:
    mihomo.py update_sub
    sudo launchctl kickstart -k system/org.nixos.mihomo
