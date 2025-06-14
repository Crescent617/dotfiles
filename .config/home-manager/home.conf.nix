{ config, pkgs, fonts, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in

{
  imports = [ ./custom/systemd.nix ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    maple-mono.truetype # Maple Mono (Ligature TTF unhinted)
    maple-mono.NF-CN-unhinted # Maple Mono NF CN (Ligature unhinted)

    # Terminal Utilities
    zsh
    curl
    unzip
    git
    htop
    btop
    neovim
    podlet # use to gengerate podman systemd service (quadlet)
    starship # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    todo-txt-cli
    gomi # A command-line trash can for Linux
    zoxide # A faster way to navigate your filesystem
    jq # A lightweight and flexible command-line JSON processor
    jqp # jq with a terminal UI
    yq-go # A lightweight and portable command-line YAML processor
    atuin # A shell history assistant that helps you find and reuse commands
    boxes # A command-line tool for creating ASCII art boxes around text
    direnv # A shell extension that loads environment variables from .env files
    tree-sitter # A CLI for parsing and analyzing source code
    choose # A command-line tool for making choices
    pay-respects # A tool to correct your previous console command
    asciinema # A tool for recording and sharing terminal sessions
    gotty # A tool for sharing your terminal as a web application
    watchexec # A tool for watching files and executing commands when they change
    trufflehog # Find, verify, and analyze leaked credentials
    earthly # Like Dockerfile and Makefile had a baby.
    miniserve # A tiny web server for static files

    # Git Tools
    lazygit
    lazydocker
    delta # A syntax-highlighter for git and diff output
    git-open
    gh # GitHub CLI
    fzf-git-sh # fzf git shortcuts

    # Search & Navigation
    fzf
    ripgrep
    fd # A simple, fast and user-friendly alternative to 'find'
    tmux
    yazi # A command-line tool for managing and navigating your filesystem
    television # like fzf but for your terminal
    clipse # A command-line tool for managing clipboard history

    # System Tools
    duf # Disk Usage/Free Utility
    dust # A more intuitive version of du in rust
    tree
    gping
    bottom # A cross-platform graphical process/system monitor with a customizable interface and a multitude of features
    progress # Coreutils progress viewer
    hyperfine # A command-line benchmarking tool
    fastfetch # A command-line system information tool written in Rust
    ncdu # A disk usage analyzer with an ncurses interface
    procs # A replacement for 'ps' written in Rust
    bat # A cat clone with wings
    lsd # A modern replacement for 'ls'

    # Network & Web Tools
    dogdns
    whois
    pup # HTML parsing tool
    httpie # A user-friendly command-line HTTP client for the API era
    mycli # A command-line interface for MySQL with autocompletion and syntax highlighting
    pgcli # A command-line interface for PostgreSQL with autocompletion and syntax highlighting
    rustscan # A fast, simple and powerful network scanner
    aria2 # A download utility for HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink
    tshark # capture and analyze network packets

    # Document & Content Tools
    zk # A CLI for Zettelkasten note taking
    glow # Render markdown on the CLI, with pizzazz!
    chafa # Image-to-text converter supporting ANSI, ASCII and HTML

    # Development Tools
    # superfile # A command-line tool to manage and manipulate files
    just # A handy way to save and run project-specific commands
    ast-grep
    devbox # A development environment manager
  ] ++ lib.optionals isLinux [
    go
    rustup
    systemctl-tui # A TUI for managing systemd services
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';
  home.file = {
    ".cache/home.nix".source = ~/.config/home-manager/home.nix;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$HOME/.local/bin:$HOME/my-busybox/bin:$PATH";
    GOPROXY = lib.mkDefault "https://goproxy.cn"; # use mkDefault to set overridable value
    FZF_DEFAULT_OPTS = " \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --color=selected-bg:#45475a \
      --multi";
    RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup";
    RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
    WEBKIT_DISABLE_DMABUF_RENDERER = "1"; # fix: https://github.com/tauri-apps/tauri/issues/7910
    UV_DEFAULT_INDEX = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
    ZK_NOTEBOOK_DIR = "$HOME/notes";
    GOEXPERIMENT = "aliastypeparams";
    GOOSE_DISABLE_KEYRING = 1; # https://github.com/block/goose/issues/2787
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
        j = "z";
        rm = "gomi";
        lazypodman = "DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker";
        lg = "lazygit";
        gmt = "go mod tidy";
        icat = "kitty +icat";
        t = "todo.sh";
        s = "kitty +kitten ssh";
        # yadm: a dotfile manager for git
        yss = "yadm status";
        yadd = "yadm add";
        ycmsg = "yadm commit -m";
        ydca = "yadm diff --cached";
        ypush = "yadm push";
        ypull = "yadm pull";
        ylog = "yadm log --oneline --graph --decorate --all";
        lazyyadm = "lazygit --git-dir=$HOME/.local/share/yadm/repo.git --work-tree=$HOME";
      };
      defaultKeymap = "emacs";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "gitignore" # gi command to generate .gitignore
          "sudo"
          "fancy-ctrl-z"
          "tmux"
          "zsh-interactive-cd"
          "direnv"
        ];
      };
      envExtra = ''
        export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
      '';
      initContent = ''
        eval "$(devbox global shellenv)"
        source ~/.nix-profile/share/fzf-git-sh/fzf-git.sh
        command -v motd.sh &>/dev/null && motd.sh
      '';
    };
    atuin.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    yazi.enable = true;
    pay-respects.enable = true;
  };

  services = {
    home-manager.autoExpire = {
      enable = true;
    };
  };
}
