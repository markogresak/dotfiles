#
# iTerm config for mac:
#2  Navigation:
#   - Alt + left: Send Escape Sequence, Esc + b
#   - Alt + right: Send Escape Sequence, Esc + f
#   - Alt + backspace: Send Hex Code, 0×17
#
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# INSTALL powerline fonts: https://github.com/powerline/fonts
# If using iterm, disable
#   Settings > Profile > Text > Treat ambigious characters as double width
ZSH_THEME="agnoster"
export TERM="xterm-256color"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins
plugins=(git git-extras sudo vagrant)
# plugins=(git git-extras brew npm vagrant sudo osx atom)

# PATH and other global variables
source ~/.globalsrc
source ~/.secretrc
# history size
HISTFILESIZE=10000

# oh-my-zsh config
source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="atom ~/.zshrc"
alias ohmyzsh="atom ~/.oh-my-zsh"

# check for $proj value and cd if set.
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

git-open () {
  # Display error message if not located in git repository.
  if ! $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
    >&2 echo "Not in git repository. Aborting."
    return 1
  fi
  # Get first argument or use default of 'origin'.
  local remote=${1:-origin}
  # Export remote to be used with `$ENV` in perl.
  export remote=$remote
  # Set $match as:
  #   list git remote(s),
  #   pipe each line to perl, which executes:
  #     get url of remote environment variable,
  #     perform regex search on current line, returns match if
  #       it starts with remote and ends with `(push)`
  #     if remote url starts with `s://`, leave it as is, otherwise
  #       replace `:` in remote url with `/` (to get valid http url)
  #     set prefix as `http` (http + s://github...), or as `http://`
  #       if the url doesn't start with `s://` (i.e. git@github... url)
  #     print url with prepended $prefix, if regex search matched.
  local match_url=$(git remote -v |
  perl -ne '
    my $remote = $ENV{'remote'};
    my $match = (/(?<=$remote\s(git@|http))(.*)(?=\s\(push\))/);
    my $url = $2;
    my $prefix = "http";
    # if $match stats with "s", treat it as https url instead of git@
    if (index($url, "s://") != 0) {
      $prefix = "http://";
      $url = $url =~ s/:/\//r;
    }
    print "$prefix$url" if $match;')
  # If match was successfuly set, open it in browser,
  #   otherwise output an error message.
  if [[ -n "$match_url" ]]; then
    open "$match_url"
  else
    >&2 echo "No match for remote '$remote'."
  fi
  # Unset exported remote so it doesn't pollute global scope.
  unset remote
}
alias gopn="git-open"
alias gopen="git-open"

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
  # echo "addons:
  # sauce_connect: true" >> .travis.yml
  travis encrypt SAUCE_USERNAME=$SAUCE_USERNAME --add
  travis encrypt SAUCE_ACCESS_KEY=$SAUCE_ACCESS_KEY --add
}

tsdi () {
  tsd install $@ -s
}

odttopdf () {
  loDir="~/Applications/LibreOffice.app"
  if [ -d "$loDir" ]; then
    ~/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to pdf $@
  else
    echo "LibreOffice not installed (Folder $loDir does not exist)."
  fi
}

# load NVM (Node Version Manager) script
source /usr/local/opt/nvm/nvm.sh
nvm alias default iojs > /dev/null 2>&1
