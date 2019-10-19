export NVM_DIR="$HOME/.nvm"
# brew --prefix nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" --no-use

# this is very slow, do a manual `nvm use` where it applies
# function nvm_use_on_cd {
#   nvm use > /dev/null 2>&1 || true
# }
# # run on every cd
# chpwd_functions=(${chpwd_functions[@]} "nvm_use_on_cd")
