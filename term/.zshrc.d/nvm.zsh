# disabled because it's slow, do a manual `nvm use` where it applies
# function nvm_use_on_cd {
#   nvm use > /dev/null 2>&1 || true
# }
# # run on every cd
# chpwd_functions=(${chpwd_functions[@]} "nvm_use_on_cd")

export NVM_DIR="$HOME/.nvm"

# A workaround to sourcing nvm script path because `nvm use` is slow
local NODE_VERSION="$(cat $NVM_DIR/alias/lts/* | tail -1)"
export PATH="$PATH:$NVM_DIR/versions/node/$NODE_VERSION/bin"
