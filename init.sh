#!/bin/bash

cd "$(dirname "$0")"

# Function to handle linking files or directories
mkln() {
  local src=$(realpath "$1")
  local dest="$2"
  local name=$(basename "$src")
  local text="$3"

  # if target is empty, use the .config directory
  if [ -z "$dest" ]; then
    dest=~/.config/$(basename "$src")
  fi

  if [ ! -e "$dest" ]; then
    ln -s "$src" "$dest"
    echo "🔗 $name linked"
    [ ! -z "$text" ] && echo "$text"
    return 0 # Successfully linked
  fi

  echo "😹 $name already exists"
  return 1 # Already exists
}

# Install TPM
target=~/.tmux/plugins/tpm
if [ ! -d $target ]; then
  git clone https://github.com/tmux-plugins/tpm $target
  echo "🔗 TPM linked"
else
  echo "😹 TPM already exists"
fi

# Link configurations
desc="Run 'home-manager init' to initialize home-manager. Then follow home-manager/README.md to modify the home.nix."
mkln "./home-manager" '' "$desc"
mkln "./awesome"
mkln "./nvim"
