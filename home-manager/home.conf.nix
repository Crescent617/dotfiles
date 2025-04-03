{ config, pkgs, fonts, lib, ... }:

let
  isLinux = builtins.match ".*-linux" builtins.currentSystem != null;
in

{
  home.packages = with pkgs; [
    # lang
    nodejs_22
    zsh
    uv # venv manager for python
    # cli
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
    lazygit
    lazydocker
    fzf
    ripgrep
    fd # A simple, fast and user-friendly alternative to 'find'
    tmux
    duf # Disk Usage/Free Utility
    dust # A more intuitive version of du in rust
    delta # A syntax-highlighter for git and diff output
    tree
    gping
    dogdns
    git-open
    whois
    pup # HTML parsing tool
    zk # A CLI for Zettelkasten note taking
    glow # Render markdown on the CLI, with pizzazz!
    httpie # A user-friendly command-line HTTP client for the API era
    yazi
    bottom # A cross-platform graphical process/system monitor with a customizable interface and a multitude of features
    progress # Coreutils progress viewer
    mycli
    gh # GitHub CLI
    hyperfine # A command-line benchmarking tool
    fastfetch # A command-line system information tool written in Rust
    # superfile
    gitmux
    just # A handy way to save and run project-specific commands
    chafa # Image-to-text converter supporting ANSI, ASCII and HTML
    ast-grep
    devbox # A development environment manager
  ] ++ (if isLinux then [
    go
    rustup
    copyq # Clipboard manager with advanced features
    flameshot # Powerful yet simple to use screenshot software
  ] else [ ]);


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
    ".tmux.conf".source = ~/.config/home-manager/d/.tmux.conf;
    ".todo.cfg".source = ~/.config/home-manager/d/.todo.cfg;
    ".vimrc".source = ~/.config/home-manager/d/.vimrc;
    ".config/containers/registries.conf".source = ~/.config/home-manager/d/containers/registries.conf;
    ".config/starship.toml".source = ~/.config/home-manager/d/starship.toml;
    ".config/wezterm".source = ~/.config/home-manager/d/wezterm;
    ".cargo/config.toml".source = ~/.config/home-manager/d/cargo.toml;
    ".pip/pip.conf".source = ~/.config/home-manager/d/pip.conf;
    ".config/alacritty/alacritty.toml".source = ~/.config/home-manager/d/alacritty.toml;
    ".gitmux.conf".source = ~/.config/home-manager/d/.gitmux.conf;
    ".cache/hm-current-config.nix".source = ~/.config/home-manager/home.nix;
  } // (if isLinux then {
    ".config/picom.conf".source = ~/.config/home-manager/d/picom.conf;
    ".config/rofi".source = ~/.config/home-manager/d/rofi;
    ".Xresources".source = ~/.config/home-manager/d/.Xresources;
    ".config/kitty/kitty.conf".source = ~/.config/home-manager/d/kitty.conf;
    ".gitconfig".source = ~/.config/home-manager/d/.gitconfig;
  } else { });

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH = "$HOME/.local/bin:$HOME/repos/my-busybox/bin:$PATH";
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
  };

  programs.zsh = {
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
      # docker = "podman";
      # docker-compose = "podman-compose";
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
      ];
    };
    envExtra = ''
      export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
    '';
    initExtraBeforeCompInit = ''
      command -v motd.sh &>/dev/null && motd.sh
    '';
  };
  programs.fzf = {
    enable = true;
    tmux = {
      enableShellIntegration = true;
    };
  };
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  services = { };

  # imports = [ ./custom/systemd.nix ];
  # custom.systemd =
  #   if isLinux then {
  #     podman.enable = false;
  #     mariadb.enable = false;
  #     ddns-go.enable = false;
  #     # gotify.enable = true;
  #     clickhouse.enable = false;
  #   } else { };
}
