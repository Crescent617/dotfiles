#!/bin/bash

cd "$(dirname "$0")"

# Function to print error messages
error() {
  local message="$1"
  echo -e "\033[31m  $message\033[0m" # Red color
}

# Function to print warning messages
warn() {
  local message="$1"
  echo -e "\033[33m  $message\033[0m" # Yellow color
}

# Function to print info messages
info() {
  local message="$1"
  echo -e "\033[32m  $message\033[0m" # Green color
}

# Function to handle linking files or directories
mkln() {
  local src=$(realpath "$1")
  local dest="$2"
  local name=$(basename "$src")
  local text="$3"

  # check if src is empty directory
  if [ ! -e "$src" ]; then
    error "$name does not exist"
    return 1
  fi

  # check if src is an empty directory
  if [ -d "$src" ] && [ -z "$(ls -A "$src")" ]; then
    warn "$name is an empty directory"
    return 1
  fi

  # if target is empty, use the .config directory
  if [ -z "$dest" ]; then
    dest=~/.config/$(basename "$src")
  fi

  if [ ! -e "$dest" ]; then
    ln -s "$src" "$dest"
    info "$name -> $dest"
    [ ! -z "$text" ] && echo "$text"
    return 0 # Successfully linked
  fi

  warn "$name already exists"
  return 1 # Already exists
}

# Install TPM
target=~/.tmux/plugins/tpm
if [ ! -d $target ]; then
  git clone https://github.com/tmux-plugins/tpm $target
  info "TPM linked"
else
  warn "TPM already exists"
fi

# Link configurations
desc="Run 'home-manager init' to initialize home-manager. Then follow home-manager/README.md to modify the home.nix."
mkln "./home-manager" '' "$desc"
mkln "./awesome"
mkln "./nvim"
