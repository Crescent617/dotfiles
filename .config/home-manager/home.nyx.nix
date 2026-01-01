{ config, pkgs, fonts, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  preferUnstable = name: if pkgs ? unstable then pkgs.unstable."${name}" else pkgs."${name}";
in
{
  home.packages = with pkgs; [
    # Terminal Utilities
    unzip
    htop
    btop
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
    pay-respects # A tool to correct your previous console command
    asciinema # A tool for recording and sharing terminal sessions
    watchexec # A tool for watching files and executing commands when they change
    miniserve # A tiny web server for static files
    yadm
    (preferUnstable "just") # A handy way to save and run project-specific commands
    ast-grep # A command-line tool for parsing and analyzing source code with AST
    zip
    croc # A tool for sending files and folders securely and easily
    tmux
    (preferUnstable "zellij") # tmux-like written in rust

    # Git Tools
    lazygit
    delta # A syntax-highlighter for git and diff output
    git-lfs
    (preferUnstable "git-extras")
    git-open
    tig # A command-line tool for browsing git repositories
    gh # GitHub CLI
    fzf-git-sh # fzf git shortcuts

    # docker
    lazydocker
    ctop

    # Search & Navigation
    fzf
    ripgrep
    fd # A simple, fast and user-friendly alternative to 'find'
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
    bat # A cat clone with wings

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
    grpcurl # A command-line tool for making gRPC requests
    tcpdump # A command-line packet analyzer
    socat
    netcat
    gost # A simple, fast and secure tunnel for TCP/UDP/HTTP/SOCKS5/SSH/WebSocket

    # Document & Content Tools
    zk # A CLI for Zettelkasten note taking
    glow # Render markdown on the CLI, with pizzazz!
    chafa # Image-to-text converter supporting ANSI, ASCII and HTML
    imagemagick

    # Media
    ffmpeg

    # Development Tools
    k9s
    process-compose
    pnpm
    bun # A fast all-in-one JavaScript runtime
    grpcui
    hey # http performance benchmarking tool
    ghz # A gRPC benchmarking and load testing tool
    cargo-autoinherit

    # devenv # A tool for managing development environments 不太 UNIX 哲学，功能过于复杂，暂时不使用
    # AI Tools
    (preferUnstable "goose-cli")
    (preferUnstable "claude-code")
    nur.repos.charmbracelet.crush

    # Nix
    nix-init # A command-line tool to initialize Nix projects
    nix-search-cli
    nix-search-tv
    nix-prefetch-github # A command-line tool to fetch and display information about GitHub repositories for Nix packages

    # Lang
    (preferUnstable "go")
    (preferUnstable "rustup")
    (preferUnstable "zig")

    # misc
    pokeget-rs # A command-line Pokémon card collector and manager
    starsheep
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPROXY = lib.mkDefault "https://goproxy.cn";
    FZF_DEFAULT_OPTS =
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a --multi";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    # fix: https://github.com/tauri-apps/tauri/issues/7910
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
    UV_DEFAULT_INDEX = "https://mirrors.ustc.edu.cn/pypi/simple";
    ZK_NOTEBOOK_DIR = "$HOME/notes";
    GOOSE_DISABLE_KEYRING = 1;
    CGO_ENABLED = 1;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/my-busybox/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
  ];

  programs = {
    neovim = {
      enable = true;
    };
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
        ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}'";

        proxy-toggle = "source proxy-toggle.sh";
        claude-yolo = " claude --dangerously-skip-permissions";

        # git
        gwtsw = "source gwtsw.sh";
        grbmb = "git rebase -i --autosquash $(git merge-base $(git_main_branch) HEAD)";
      };
      defaultKeymap = "emacs";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "fancy-ctrl-z"
          "git"
          "git-extras"
          "gitignore" # gi command to generate .gitignore
          "golang"
          "helm"
          "kubectl"
          "sudo"
          "tmux"
        ];
      };
      initContent = ''
        command -v motd.sh &>/dev/null && motd.sh
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
        command -v starsheep &>/dev/null && eval "$(starsheep init zsh)"
        # fallback to starship, if last command fail
        if [ $? -ne 0 ]; then
          eval "$(starship init zsh)"
        fi
      '';
    };
    fzf.enable = true;
    atuin.enable = true;
    # starship.enable = true;
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
    # pay-respects.enable = true; # like fuck command
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
