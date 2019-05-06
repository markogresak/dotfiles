HISTFILESIZE=25000

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell-custom"

# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Disable marking untracked VCS files as dirty.
# This makes repository status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  sudo
)

source $ZSH/oh-my-zsh.sh
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export SSH_KEY_PATH="~/.ssh/id_rsa"

export EDITOR="code"

export NODE_ENV="development"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export GEM_HOME="~/.gem"
export GEM_PATH="~/.gem"
export PATH="/usr/local/sbin:$PATH:$GEM_PATH/bin"

# path alises (inspired by wd)
local projects_path="~/Projects"
alias projects="$projects_path"
alias prezly="$projects_path/prezly/prezly"
alias backend="$projects_path/prezly/prezly/apps/backend"
alias press="$projects_path/prezly/prezly/apps/press"
alias website="$projects_path/prezly/website"
alias other="$projects_path/other"

alias wd="alias | grep -E \"\w+='~\" | sed \"s/'//g\" | sed 's/=/ => /'"

if [[ -z $_PATH_ALIASES_EXPORTED_ ]]; then
    # Export each alias (detected by `wd`) as a variable named after the alias.
    while read path_alias; do
    local path_export=$(echo $path_alias | sed 's/ => /=/')
    local export_name=$(echo $path_export | cut -d= -f1)
    if env | grep -q "^$export_name="; then
        echo "Conflict: Tried to export $path_export, but it would overwrite env variable $export_name. Skipped."
    else
        eval "export $path_export"
    fi
    done <<< $(wd)
    unset path_export
    unset export_name
    export _PATH_ALIASES_EXPORTED_=true
fi

function nvm_use_on_cd() {
  nvm use 2>&1 > /dev/null || true
}
# run on every cd
chpwd_functions=(${chpwd_functions[@]} "nvm_use_on_cd")
# run when .zshrc initially loads
nvm_use_on_cd

# quick way to grep history
function h {
    omz_history | grep "$@"
}

alias mergepdf="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py"

alias gopn="git-open"
alias gpo="gp ; gopn"
