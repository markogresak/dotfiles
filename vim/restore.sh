#!/bin/bash

source ./config_files

for file in ${config_files[@]}; do
  mkdir -p $(dirname "$file")
  cp "$file" "$HOME"
  echo "Restored $file to $HOME/$file"
done

unset config_files

install_vundle_log="install_vundle.log"

function install_vundle {
  if [[ ! -d "~/.vim/bundle/Vundle.vim" ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &> $install_vundle_log
    echo "" >> $install_vundle_log
    vim +PluginInstall +qall &>> $install_vundle_log
  fi
}

install_vundle
