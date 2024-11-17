{ config, pkgs, fonts, ... }:

let
  isLinux = builtins.match ".*-linux" builtins.currentSystem != null;
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hrli";
  home.homeDirectory = "/home/hrli";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    zsh
    curl
    git
    htop
    mcfly # desc: A replacement for ctrl-r with context-aware filtering and improved search
    neovim
    podlet # desc: use to gengerate podman systemd service (quadlet)
    python3
    starship # desc: The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    todo-txt-cli
    trash-cli
    zoxide # desc: A faster way to navigate your filesystem
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "CascadiaCode"
      ];
    })
    lazygit
    lazydocker
    fzf
    ripgrep
    fd
    tmux
    nodejs_20
    duf
    dust
    delta
    gping
    dogdns
    git-open
    whois
    pup # desc: HTML parsing tool
    zk # desc: A CLI for Zettelkasten note taking
    glow # desc: Render markdown on the CLI, with pizzazz!
    httpie # desc: A user-friendly command-line HTTP client for the API era
    yazi
    bottom # desc: A cross-platform graphical process/system monitor with a customizable interface and a multitude of features
    progress # desc: Coreutils progress viewer
    gcc
    go
    python3
    mycli
    copyq # desc: Clipboard manager with advanced features
    flameshot # desc: Powerful yet simple to use screenshot software
    gh # desc: GitHub CLI
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".editorconfig".source = ~/.config/home-manager/d/.editorconfig;
    ".condarc".source = ~/.config/home-manager/d/.condarc;
    ".gitconfig".source = ~/.config/home-manager/d/.gitconfig;
    ".tmux.conf".source = ~/.config/home-manager/d/.tmux.conf;
    ".todo.cfg".source = ~/.config/home-manager/d/.todo.cfg;
    ".vimrc".source = ~/.config/home-manager/d/.vimrc;
    ".config/containers".source = ~/.config/home-manager/d/containers;
    ".config/picom.conf".source = ~/.config/home-manager/d/picom.conf;
    ".config/starship.toml".source = ~/.config/home-manager/d/starship.toml;
    ".config/kitty/kitty.conf".source = ~/.config/home-manager/d/kitty.conf;
    ".config/wezterm".source = ~/.config/home-manager/d/wezterm;
    ".cargo/config.toml".source = ~/.config/home-manager/d/cargo.toml;
    ".config/nvim".source = ~/.config/home-manager/d/nvim;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hrli/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    MCFLY_RESULTS = "50";
    PATH = "$HOME/.local/bin:$HOME/repos/my-busybox/bin:$PATH";
    GOPROXY = "https://goproxy.cn";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
        j = "z";
        rm = "trash";
        lazypodman = "DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker";
        docker = "podman";
        docker-compose = "podman-compose";
      };
      defaultKeymap = "emacs";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "fancy-ctrl-z"
          "tmux"
        ];
      };
      envExtra = ''
        . $HOME/.cargo/env
      '';
      initExtraBeforeCompInit = ''
        todo.sh list
      '';
    };
    mcfly.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    gh.enable = true;
  };

  systemd.user.services =
    if isLinux then {
      podman = {
        Unit = {
          Description = "Podman service";
          After = [ "network.target" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "/usr/bin/podman system service --time 0";
          Restart = "always";
        };
      };
    } else { };


  services =
    if isLinux then {
      flameshot.enable = false;
      copyq.enable = true;
    } else { };

  # BUG: home-manager podman has bug, so only use systemd to start podman service
  # dotfiles on  main [✘»!+]
  # ❯ podman --log-level debug images
  # ERRO[0000] running `/home/hrli/.nix-profile/bin/newuidmap 9883 0 1000 1 1 100000 65536`: newuidmap: write to uid_map failed: Operation not permitted
  # Error: cannot set up namespace using "/home/hrli/.nix-profile/bin/newuidmap": should have setuid or have filecaps setuid: exit status 1

  # services.podman.enable = true;
  # services.podman.containers = {
  #   mariadb = {
  #     image = "mariadb";
  #     environment = {
  #       MYSQL_ROOT_PASSWORD = "root";
  #     };
  #     ports = [ "127.0.0.1:3306:3306" ];
  #     volumes = [ "mariadb_data:/var/lib/mysql" ];
  #   };
  #   gotify = {
  #     image = "gotify/server";
  #     ports = [ "7777:80" ];
  #     volumes = [ "gotify-data:/app/data" ];
  #   };
  #   ddns-go = {
  #     image = "jeessy/ddns-go";
  #     network = "host";
  #     volumes = [ "ddns-go-data:/root" ];
  #   };
  #   clickhouse = {
  #     image = "clickhouse/clickhouse-server";
  #     ports = [ "127.0.0.1:8123:8123" "127.0.0.1:9000:9000" ];
  #     volumes = [
  #       "ch_data:/var/lib/clickhouse"
  #       "ch_config:/etc/clickhouse-server"
  #       "ch_logs:/var/log/clickhouse-server"
  #     ];
  #   };
  # };
}
