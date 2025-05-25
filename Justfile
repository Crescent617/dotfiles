[private]
default:
    @just --list

sync:
    @echo "Syncing..."
    yadm pull
    yadm alt -v
    home-manager switch
    cd ./my-busybox/ && git pull

[macos]
upgrade:
    @echo "Updating..."
    brew update && brew upgrade
    nix-channel --update && home-manager switch


[linux]
upgrade:
    @echo "Updating..."
    nix-channel --update && home-manager switch
    yay -Syu --noconfirm
