# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export TERM='xterm-256color'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="powerline"
# INSTALL powerline fonts: https://github.com/powerline/fonts
# If using iterm, disable
#   Settings > Profile > Text > Treat ambigious characters as double width
# Powerline readme: https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme
POWERLINE_RIGHT_A="exit-status"
POWERLINE_RIGHT_B="none"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_HIDE_USER_NAME="true"
POWERLINE_NO_BLANK_LINE="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
plugins=(git git-extras git-flow npm osx sudo web-search)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# PATH and other global variables
source ~/.globalsrc
# powerline bindings
source /Users/markogresak/Documents/dev/powerline/powerline/bindings/zsh/powerline.zsh
# history size
HISTFILESIZE=10000

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# oh-my-zsh config
source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"

cdproj () {
  if [[ -n "$proj" ]]; then
    cd "$proj"
  else
    echo 'Project variable $proj is not set! Aborted.'
  fi
}

mkc () {
  mkdir -p "$@" && cd "$@"
}

cloneorg () {
  local PERL_SIGNALS="unsafe"
  for i in "$@"; do
    mkc $i
    curl -s "https://api.github.com/orgs/$i/repos" | perl -ne '(system("zsh", "-c", "echo \"Cloning into \\\"$1\\\"...\"; { git clone -q https://github.com/$1 || exit 1 } &") == 0 or die "Error occured while cloning.") if /(?<="full_name"\: ")(.+?)(?=")/g; system("wait")'
    cd ..
  done;
}

travis-add-sauce () {
  # check for travis command
  command -v travis >/dev/null 2>&1 ||
    { echo >&2 'Command travis is not installed. Use `gem install travis` to install it. Aborted.'; exit 1; }

  # check for .travis.yml file
  test -f .travis.yml ||
    { echo >&2 'File .travis.yml not present. Use `travis init` and try again. Aborted.'; exit 1; }

  grep -q "sauce_connect" .travis.yml &&
    { echo >&2 'File .travis.yml already contains sauce_connect attribute. Aborted.'; exit 1; }

  # check for sauce credentials
  [[ -n "$SAUCE_USERNAME" ]] && [[ -n "$SAUCE_ACCESS_KEY" ]] ||
    { echo >&2 'You forgot to set $SAUCE_USERNAME and/or $SAUCE_ACCESS_KEY variables. Check SauceLabs docs. Aborted.'; exit 1; }

  echo 'Adding encrypted SAUCE_USERNAME and SAUCE_ACCESS_KEY globals to .travis.yml'
  echo "addons:
  sauce_connect: true" >> .travis.yml
  travis encrypt SAUCE_USERNAME=$SAUCE_USERNAME --add
  travis encrypt SAUCE_ACCESS_KEY=$SAUCE_ACCESS_KEY --add
}

# gulp completions
eval "$(gulp --completion=zsh)"

# load NVM (Node Version Manager) script
source $(brew --prefix nvm)/nvm.sh
