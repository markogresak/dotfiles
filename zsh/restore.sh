#!/bin/bash

source ./config_files

for file in ${config_files[@]}; do
  mkdir -p $(dirname "$file")
  cp "$file" "$HOME"
  echo "Restored $file to $HOME/$file"
done

unset config_files

touch ~/.secretrc
echo 'Please restore ~/.secretrc manually.'

install_zsh_log="install_zsh.log"

function install_zsh {
  if [[ ! -d "~/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &> $install_zsh_log
  fi
}

install_zsh
