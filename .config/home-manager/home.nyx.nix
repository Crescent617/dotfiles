{ config, pkgs, fonts, lib, ... }:

{
  home.packages = with pkgs; [
    # Terminal Utilities
    unzip
    htop
    btop
    neovim
    starship # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    todo-txt-cli
    gomi # A command-line trash can for Linux
    zoxide # A faster way to navigate your filesystem
    jq # A lightweight and flexible command-line JSON processor
    jqp # jq with a terminal UI
    yq-go # A lightweight and portable command-line YAML processor
    atuin # A shell history assistant that helps you find and reuse commands
    boxes # A command-line tool for creating ASCII art boxes around text
    tree-sitter # A CLI for parsing and analyzing source code
    choose # A command-line tool for making choices
    pay-respects # A tool to correct your previous console command
    asciinema # A tool for recording and sharing terminal sessions
    watchexec # A tool for watching files and executing commands when they change
    earthly # Like Dockerfile and Makefile had a baby.
    miniserve # A tiny web server for static files
    yadm
    just # A handy way to save and run project-specific commands
    ast-grep # A command-line tool for parsing and analyzing source code with AST

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
    lnav

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
    speedtest-go # A command-line tool to test internet speed
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
    goose-cli # AI cli agent
    chafa # Image-to-text converter supporting ANSI, ASCII and HTML

    # Media
    ffmpeg

    # Development Tools
    k9s
    gitRepo

    # Lang
    rustup
    go
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPROXY = lib.mkDefault "https://goproxy.cn";
    FZF_DEFAULT_OPTS =
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a --multi";
    RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup";
    RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
    # fix: https://github.com/tauri-apps/tauri/issues/7910
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    UV_DEFAULT_INDEX = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
    ZK_NOTEBOOK_DIR = "$HOME/notes";
    GOOSE_DISABLE_KEYRING = 1;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/my-busybox/bin"
    "$HOME/go/bin"
  ];

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
        j = "z";
        trash = "gomi";
        lazypodman =
          "DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker";
        lg = "lazygit";
        gmt = "go mod tidy";
        icat = "kitty +icat";
        t = "todo.sh";
        # yadm: a dotfile manager for git
        yss = "yadm status";
        yadd = "yadm add";
        ycmsg = "yadm commit -m";
        ydca = "yadm diff --cached";
        ypush = "yadm push";
        ypull = "yadm pull";
        ylog = "yadm log --oneline --graph --decorate --all";
        lazyyadm = "lazygit --git-dir=$HOME/.local/share/yadm/repo.git --work-tree=$HOME";

        proxy-toggle = "source proxy-toggle.sh";
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
        ];
      };
      initContent = ''
        command -v motd.sh &>/dev/null && motd.sh
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
      '';
    };
    fzf.enable = true;
    atuin.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    yazi = {
      enable = true;
      plugins = {
        mount = pkgs.yaziPlugins.mount;
      };
      keymap = {
        mgr.prepend_keymap = [
          { on = "M"; run = "plugin mount"; }
        ];
      };
    };
    pay-respects.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
