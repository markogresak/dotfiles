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
source ~/.secretrc
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
    curl -s "https://api.github.com/orgs/$i/repos" |
      perl -ne '(system("zsh", "-c", "echo \"Cloning into \\\"$1\\\"...\";
          { git clone -q https://github.com/$1 || exit 1 } &") == 0
            or die "Error occured while cloning.")
        if /(?<="full_name"\: ")(.+?)(?=")/g; system("wait")'
    cd ..
  done;
}

github-init () {
  # check if currently in repo
  # if ! $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
  #   # not in repo, use git init to start one
  #   git init
  # fi
  # Test for GitHub credentials, fails if missing.
  if [[ -z "$GITHUB_USERNAME" ]] || [[ -z "$GITHUB_TOKEN" ]]; then
    >&2 echo 'Missing $GITHUB_USERNAME and/or $GITHUB_TOKEN. Aborted.'
    return 1
  fi

  # Parse command line options.
  # Reset in case getopts has been used previously in the shell.
  OPTIND=1
  # Get options `o` and `p`.
  while getopts "op" opt; do
    case "$opt" in
      o) open_browser=1 ;;
      p) private_repo=1 ;;
    esac
  done
  # Shift opts back to start.
  shift $((OPTIND-1)); [ "$1" = "--" ] && shift
  # Return code, changes if error occurs.
  local return_code=0
  # Path to GitHub API for creating new repository.
  local api_path="https://api.github.com/user/repos"
  # Build string of <username>:<token> to auth on the API.
  local api_auth="$GITHUB_USERNAME:$GITHUB_TOKEN"
  # Determine repository name by current folder name.
  local repo_name=$(basename $PWD)
  # Set string for private repo attribute.
  # API attribute defaults to false, set to true only with `-p` option.
  if [[ $private_repo == 1 ]]; then private=', "private":"true"'; fi
  # Request data string (JSON), API requires only repository name.
  # All inputs: https://developer.github.com/v3/repos/#input
  local data="{\"name\":\"$repo_name\" $private}"
  # File to store reponse, parsed in case of error.
  local tmp='.tmp-api-response'
  # Perform request to API, write output to $tmp and store response http_code.
  local response_code=$(curl -su "$api_auth" -d "$data" -o "$tmp" -w "%{http_code}" "$api_path")
  # If response code is below 300 (OK code), request successfully created new repository.
  # (Should respond with only 201 for success, but better be safe.)
  if (( $response_code < 300 )); then
    # Parse repository URL from response string, it's the last `html_url` attribute.
    local url=$(cat $tmp | perl -ne 'print "$1\n" if /(?<="html_url": ")(.+?)(?=")/' | tail -1)
    # Output repository name and URL.
    echo -e "Successfuly created repository '$repo_name'\nURL: $url"
    # Check if currently located in git repository.
    if ! $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
      # Not in git repository, use `git init` to initialise one.
      echo "No git project present, initialising..."
      git init
    fi
    # Add returned url as origin.
    git remote add origin $url
    # If option open_browser is set, open url in browser.
    if [[ "$open_browser" == 1 ]]; then open $url; fi
  # Repository creation failed.
  else
    # Output error messages from response.
    m=$(cat $tmp | perl -ne 'print "$1: " if /(?<="message": ")(.+?)(?=")/' | rev | cut -c 3- | rev)
    >&2 echo "Failed to create '$repo_name': $m"
    # Set return code to 1 (error).
    return_code=1
  fi
  # Remove response output file.
  rm $tmp
  # Exit with return_code, which is 0, unless error occured.
  return $return_code
}
alias ghinit="github-init"

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
