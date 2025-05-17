{ config, pkgs, fonts, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  hasSystemd = lib.pathExists "/run/systemd/system";
in

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Terminal Utilities
    zsh
    curl
    unzip
    git
    htop
    neovim
    podlet # use to gengerate podman systemd service (quadlet)
    starship # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    todo-txt-cli
    trash-cli
    zoxide # A faster way to navigate your filesystem
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # Maple Mono NF CN (Ligature unhinted)
    maple-mono.NF-CN-unhinted
    jq # A lightweight and flexible command-line JSON processor
    jqp # jq with a terminal UI
    yq-go # A lightweight and portable command-line YAML processor
    atuin # A shell history assistant that helps you find and reuse commands
    boxes # A command-line tool for creating ASCII art boxes around text
    direnv # A shell extension that loads environment variables from .env files
    tree-sitter # A CLI for parsing and analyzing source code

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

    # System Monitoring
    duf # Disk Usage/Free Utility
    dust # A more intuitive version of du in rust
    tree
    gping
    bottom # A cross-platform graphical process/system monitor with a customizable interface and a multitude of features
    progress # Coreutils progress viewer
    hyperfine # A command-line benchmarking tool
    fastfetch # A command-line system information tool written in Rust

    # Network & Web Tools
    dogdns
    whois
    pup # HTML parsing tool
    httpie # A user-friendly command-line HTTP client for the API era
    mycli

    # Document & Content Tools
    zk # A CLI for Zettelkasten note taking
    glow # Render markdown on the CLI, with pizzazz!
    chafa # Image-to-text converter supporting ANSI, ASCII and HTML

    # Development Tools
    # superfile # A command-line tool to manage and manipulate files
    just # A handy way to save and run project-specific commands
    ast-grep
    devbox # A development environment manager
  ] ++ (if isLinux then [
    # Languages
    go
    rustup
    # GUI Applications
    # copyq # Clipboard manager with advanced features
    # flameshot # Powerful yet simple to use screenshot software
  ] else [ ]);


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
    GOPROXY = lib.mkDefault "https://goproxy.cn";
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
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
        j = "z";
        rm = "trash";
        lazypodman = "DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker";
        lg = "lazygit";
        gmt = "go mod tidy";
        icat = "kitty +icat";
        t = "todo.sh";
        # yadm: a dotfile manager for git
        yss = "yadm status";
        yadd = "yadm add";
        ycmsg = "yadm commit -m";
        ydiff = "yadm diff";
        ypush = "yadm push";
        ypull = "yadm pull";
        ylazy = ''GIT_DIR="$HOME/.local/share/yadm/repo.git" GIT_WORK_TREE="$HOME" lazygit'';
        ylog = "yadm log --oneline --graph --decorate --all";
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
        eval "$(gh copilot alias -- zsh)"
        source ~/.nix-profile/share/fzf-git-sh/fzf-git.sh
        command -v motd.sh &>/dev/null && motd.sh
      '';
    };
    atuin.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    yazi.enable = true;
  };

  services =
    if isLinux then {
      home-manager.autoExpire = {
        enable = true;
      };
    } else { };

  imports =
    if hasSystemd then
      [ ./custom/systemd.nix ] else [ ];
}
