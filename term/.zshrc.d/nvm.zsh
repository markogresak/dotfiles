# export NVM_DIR="$HOME/.nvm"
# not using $(brew --prefix nvm) because it's slow
# [ -s "$BREW_PATH/opt/nvm/nvm.sh" ] && . "$BREW_PATH/opt/nvm/nvm.sh" --no-use

# disabled because it's slow, do a manual `nvm use` where it applies
# function nvm_use_on_cd {
#   nvm use > /dev/null 2>&1 || true
# }
# # run on every cd
# chpwd_functions=(${chpwd_functions[@]} "nvm_use_on_cd")

# A workaround to setting node path because `nvm use` is slow
# PATH="$PATH:$NVM_DIR/versions/node/v12.16.1/bin"
