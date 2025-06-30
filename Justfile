@sync:
    cd ./my-busybox && git pull
    cd ./.config/home-manager && just sync || echo "home-manager not found"
    yadm pull

