{ config, pkgs, fonts, ... }:

let
  isLinux = builtins.match ".*-linux" builtins.currentSystem != null;
in

{
  home.packages = with pkgs; [
    zsh
    curl
    unzip
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
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
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
    tree
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
    go
    python3
    mycli
    copyq # desc: Clipboard manager with advanced features
    flameshot # desc: Powerful yet simple to use screenshot software
    gh # desc: GitHub CLI
    hyperfine # desc: A command-line benchmarking tool
    fastfetch # desc: A command-line system information tool written in Rust
    # systemctl-tui # desc: A text-based systemd manager
    # superfile
    gitmux
    just # desc: A handy way to save and run project-specific commands
    chafa # desc: Image-to-text converter supporting ANSI, ASCII and HTML
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
    ".config/containers/registries.conf".source = ~/.config/home-manager/d/containers/registries.conf;
    ".config/picom.conf".source = ~/.config/home-manager/d/picom.conf;
    ".config/starship.toml".source = ~/.config/home-manager/d/starship.toml;
    ".config/kitty/kitty.conf".source = ~/.config/home-manager/d/kitty.conf;
    ".config/wezterm".source = ~/.config/home-manager/d/wezterm;
    ".cargo/config.toml".source = ~/.config/home-manager/d/cargo.toml;
    ".config/nvim/lua".source = ~/.config/home-manager/d/nvim/lua;
    ".config/nvim/init.lua".source = ~/.config/home-manager/d/nvim/init.lua;
    ".Xresources".source = ~/.config/home-manager/d/.Xresources;
    ".Xmodmap".source = ~/.config/home-manager/d/.Xmodmap;
    ".config/rofi".source = ~/.config/home-manager/d/rofi;
    ".pip/pip.conf".source = ~/.config/home-manager/d/pip.conf;
    ".config/alacritty/alacritty.toml".source = ~/.config/home-manager/d/alacritty.toml;
    ".gitmux.conf".source = ~/.config/home-manager/d/.gitmux.conf;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    MCFLY_RESULTS = "50";
    PATH = "$HOME/.local/bin:$HOME/repos/my-busybox/bin:$PATH";
    GOPROXY = "https://goproxy.cn";
    FZF_DEFAULT_OPTS = " \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --color=selected-bg:#45475a \
      --multi";
    RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup";
    RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
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
        command -v motd.sh &>/dev/null && motd.sh
      '';
      initExtra = ''
        # >>> conda initialize >>>
        __conda_setup="$('/home/hrli/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/hrli/miniconda3/etc/profile.d/conda.sh" ]; then
                . "/home/hrli/miniconda3/etc/profile.d/conda.sh"
            else
                export PATH="/home/hrli/miniconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
      '';
    };
    mcfly = {
      enable = true;
      fzf.enable = true;
    };
    starship.enable = true;
    zoxide.enable = true;
    gh.enable = true;
  };

  services = { };

  imports = [ ./custom/systemd.nix ];
  custom.systemd =
    if isLinux then {
      podman.enable = true;
      mariadb.enable = true;
      ddns-go.enable = true;
      # gotify.enable = true;
      clickhouse.enable = true;
    } else { };
}