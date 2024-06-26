#!/bin/zsh

cur_dir=$(pwd)

echo "[$(date)] init dotfiles"

backup() {
  mv $1 "$1.$(date -u -Iseconds).bak"
}

link() {
  echo "link $1 to $2"
  if [[ -e $2 ]]; then
    echo "file exists, make backup"
    backup $2
  elif [[ -L $2 ]]; then
    echo "link exists, rm it"
    rm $2
  fi

  ln -s $1 $2
}

link "$cur_dir/.tmux.conf" "$HOME/.tmux.conf"
link "$cur_dir/.editorconfig" "$HOME/.editorconfig"
link "$cur_dir/.vimrc" "$HOME/.vimrc"
link "$cur_dir/.gitconfig" "$HOME/.gitconfig"

if [[ ! -d "$HOME/.config" ]]; then
  mkdir "$HOME/.config"
fi

link "$cur_dir/starship.toml" "$HOME/.config/starship.toml"
link "$cur_dir/zellij" "$HOME/.config/zellij"
link "$cur_dir/awesomewm" "$HOME/.config/awesome"
