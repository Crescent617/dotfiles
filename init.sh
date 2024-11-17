#!/bin/bash

set -e

cd "$(dirname "$0")"

# Install TPM
target=~/.tmux/plugins/tpm
if [ ! -d $target ]; then
  git clone https://github.com/tmux-plugins/tpm $target
else
  echo "TPM already exists"
fi

src=$(realpath ./home-manager)
target=~/.config/home-manager
if [ ! -d $target ]; then
  ln -s $src $target
else
  echo "home-manager already exists"
fi

src=$(realpath ./awesomewm)
target=~/.config/awesome
if [ ! -d $target ]; then
  ln -s $src $target
else
  echo "awesome already exists"
fi
