#!/bin/bash

VIM_BUNDLE_PATH="$HOME/.vim/pack/bundle/start"
VIM_BUNDLES_FILE="$PWD/vim_bundles"

function update_vim_bundles {
  echo -n "" > $VIM_BUNDLES_FILE
  if ! hash vim 2>/dev/null; then
    eval ../.helpers/log.sh "vim" "ERROR: vim command not found, will not check for bundles." "error"
  else
    eval ../.helpers/log.sh "vim" "Updating vim bundles..."
    for bundle in $(ls $VIM_BUNDLE_PATH); do
      bundle_path="$VIM_BUNDLE_PATH/$bundle"
      if [ -d "$bundle_path" ]; then
        cd "$bundle_path"
        git remote get-url origin >> $VIM_BUNDLES_FILE
        cd $OLDPWD
      fi
    done
    eval ../.helpers/log.sh "vim" "vim bundles updated."
  fi
}

update_vim_bundles

