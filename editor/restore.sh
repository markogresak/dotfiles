#!/bin/bash

VIM_BUNDLE_PATH="$HOME/.vim/pack/bundle/start"
VIM_BUNDLES_FILE="$PWD/vim_bundles"

function clone_bundle {
  local bundle_git_url="$1"
  local bundle_name=$(basename "$bundle_git_url" | sed 's/\.git//')
  if [ -d "$VIM_BUNDLE_PATH/$bundle_name" ]; then
    eval ../.helpers/log.sh "vim" "Bundle $bundle_name already exists, skipping add."
  else
    eval ../.helpers/log.sh "vim" "Start cloning bundle $bundle_name."
    cd $VIM_BUNDLE_PATH
    git clone "$bundle_git_url" 2> /dev/null
    cd $OLDPWD
    eval ../.helpers/log.sh "vim" "Added bundle $bundle_name."
  fi
}

function restore_vim_bundles {
  if ! hash vim 2>/dev/null; then
    eval ../.helpers/log.sh "vim" "ERROR: vim command not found, will not restore." "error"
  else
    eval ../.helpers/log.sh "vim" "Restoring vim bundles..."

    mkdir -p "$VIM_BUNDLE_PATH"

    while read bundle_git_url || [ -n "$bundle_git_url" ]; do
      clone_bundle "$bundle_git_url" &
    done < $VIM_BUNDLES_FILE

    wait

    eval ../.helpers/log.sh "vim" "vim bundles restored."
  fi
}

restore_vim_bundles
