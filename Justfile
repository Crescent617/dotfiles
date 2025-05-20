sync:
    @echo "Syncing..."
    yadm pull
    home-manager switch
    cd ./my-busybox/ && git pull
