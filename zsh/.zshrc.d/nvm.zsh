# # Original config
# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" --no-use

# A workaround to sourcing nvm script path because `nvm use` is slow
local NODE_VERSION="$(cat $NVM_DIR/alias/default | tail -1)"
export PATH="$PATH:$NVM_DIR/versions/node/$NODE_VERSION/bin"
