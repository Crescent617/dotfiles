# User configuration

cur_shell=$(basename $SHELL)

check_command() {
  if ! command -v $1 >/dev/null 2>&1; then
    echo "👻 command '$1' does not exist. Please install it first. $2"
    return 1
  fi
}

check_dir() {
  if [ ! -d $1 ]; then
    echo "👻 dir '$1' does not exist. Please create it first. $2"
    return 1
  fi
}

check_file() {
  if [ ! -f $1 ]; then
    echo "👻 file '$1' does not exist. Please create it first. $2"
    return 1
  fi
}

if check_command zplug; then
  # zplug "spwhitt/nix-zsh-completions"
  zplug "paulirish/git-open"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting"
  # zplug "jeffreytse/zsh-vi-mode"

  # Then, source plugins and add commands to $PATH
  zplug load
fi

# keymap
bindkey -r '^j' # unbind ctrl-j

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -z $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# alias
alias v=nvim
if check_command podman; then
  alias lazypodman='DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker'
fi

# --------------- APPs ----------------

if check_dir ~/repos/my-busybox; then
  export PATH=$PATH:~/repos/my-busybox/bin
fi

# vi-mode
# VI_MODE_SET_CURSOR=true

# zk
export ZK_NOTEBOOK_DIR=~/notes

if check_command mcfly; then
  # mcfly: sub <C-r> search history
  eval "$(mcfly init $cur_shell)"
  export MCFLY_RESULTS=50
fi

if check_command starship; then
  # starship prompt
  source <(starship init $cur_shell --print-full-init)
fi

[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh

if check_command xmodmap; then
  modified=$(xmodmap -pm | egrep 'control.+0x42')
  if [[ ! "$modified" ]] && [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
  fi
fi

if check_command trash; then
  alias rm='trash'
fi

if check_command todo.sh; then
  export TODOTXT_DEFAULT_ACTION=ls
  alias t='todo.sh -d ~/.todo.cfg'
fi

if [[ $TERM == "xterm-kitty" ]] && check_command kitty; then
  alias icat='kitty +kitten icat'
fi

# environment
export GOPROXY=https://goproxy.cn
export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
