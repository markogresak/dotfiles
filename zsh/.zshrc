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
# ENABLE_CORRECTION="true"

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
plugins=(git git-extras git-flow git-hubflow colored-man-pages npm sudo vagrant)
# plugins=(git git-extras brew npm vagrant sudo osx atom)

# PATH and other global variables
source ~/.globalsrc
source ~/.secretrc
# history size
HISTFILESIZE=25000

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

# set different color when in ssh
# function change-tab-color() {
#   echo -e "\033]6;1;bg;red;brightness;$1\a"
#   echo -e "\033]6;1;bg;green;brightness;$2\a"
#   echo -e "\033]6;1;bg;blue;brightness;$3\a"
# }
# function change-profile() {
#   echo -e "\033]50;SetProfile=$1\a"
# }
# function reset-colors() {
#   echo -e "\033]6;1;bg;*;Default\a"
#   change-profile Default
# }
# function colorssh() {
#   if [[ -n "$ITERM_SESSION_ID" ]]; then
#     trap "reset-colors" INT EXIT
#     # if [[ "$*" =~ "web*|production|ec2-.*compute-1" ]]; then
#       change-profile SSH
#       change-tab-color 255 0 0
#     # fi
#   fi
#   ssh $*
# }
# alias ssh="colorssh"

# check for $proj value and cd if set.
cdproj () {
  if [[ -n "$proj" ]]; then
    cd "$proj"
  else
    echo 'Project variable $proj is not set! Aborted.'
  fi
}

cddev () {
  if [[ -n "$dev" ]]; then
    cd "$dev"
  else
    echo 'Project variable $dev is not set! Aborted.'
  fi
}

alias ...="cd \$OLDPWD"

# Make directory (with intermediate path) and cd into it.
mkc () {
  mkdir -p "$@" && cd "$@"
}
alias mcd="mkc"
alias cmkdir="mkc"
alias mkdirc="mkc"

# Clone all repositories of given github organisation into folder named after org.
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

# Initialize github repo from current directory, add remote (calls git init if needed).
# Environment variables GITHUB_USERNAME and GITHUB_TOKEN have to be set!
# Token can be generated at github profile page, make sure to add correct permissions.
# Requires `curl` (requests), `perl` (better regex support) and `open` (open in browser) commands.
# All of these commands should be installed on OS X by default.
#
# Possible options and arguments:
#  * [none]: public repository, name = same as current directory name
#  * -p: private repository, name = same as current directory name
#  * -o: open repository github page in browser after repository is created
#
github-init () {
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

# Open current repository remote in browser. Remote argument is optional, defaults to origin.
# Requires `perl` (better regex support) and `open` (open in browser) commands.
# Can add option -b to open current branch
git-open () {
  open_branch=0
  # Get options `o` and `p`.
  while getopts "b" opt; do
    case "$opt" in
      b) open_branch=1 ;;
    esac
  done
  # Shift opts back to start.
  shift $((OPTIND-1)); [ "$1" = "--" ] && shift

  # Display error message if not located in git repository.
  if ! $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
    >&2 echo "Not in git repository. Aborting."
    return 1
  fi
  # Get first argument or use default of 'origin'.
  local remote=${1:-origin}
  # get push url for remote, pipe to sed is used to fix SSH urls
  local match_url=$(git remote get-url --push $remote | sed -e 's/git@//' | sed -Ee 's/(\..+):/\1\//')
  # If match was successfuly set, open it in browser, otherwise output an error message.
  # Make request to matching url, find last location and trim trailing spaces.
  resolved_url=$(curl -sLI "$match_url" | grep 'Location:' | cut -d' ' -f2 | tail -1 | sed -e 's/[[:space:]]*$//')
  # if resolved_url not found, fall back to match_url
  if [[ -z "$resolved_url" ]]; then
    resolved_url="$match_url"
  fi

  if [[ -n "$resolved_url" ]]; then
    if [[ "$open_branch" == 1 ]]; then
      current_branch=$(git rev-parse --abbrev-ref HEAD)
      open "$resolved_url/tree/$current_branch"
    else
      open "$resolved_url"
    fi
  else
    >&2 echo "No match for remote '$remote'."
  fi
  # Unset exported remote so it doesn't pollute global scope.
  unset remote
}
alias gopnn="git-open"
alias gopn="git-open -b"

# Add saucelabs credentials to .travis.yml file.
# Environment variables SAUCE_USERNAME and SAUCE_ACCESS_KEY have to be set!
# Requires `travis` (gem install travis) command.
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

# Call tsd install and save installed package(s) to tsd.json file.
tsdi () {
  tsd install $@ -s
}

# Convert libreoffice's .odt document(s) to pdf.
# Requires LibreOffice installed/linked inside $HOME/Applications.
odttopdf () {
  libre_office_dir=~/Applications/LibreOffice.app
  if [ -d "$libre_office_dir" ]; then
    "$libre_office_dir/Contents/MacOS/soffice" --headless --convert-to pdf $@
  else
    echo "LibreOffice not installed (Folder $libre_office_dir does not exist)."
  fi
}

# Usage: favicons [srcImage] (recommended >=152x152 image)
favicons () {
  # Check for imagemagick's `convert` command.
  if ! command -v convert >/dev/null 2>&1; then
    echo >&2 "Command 'convert' (imagemagick) is required, please install it."
  else
    # Check if source image argument was provided.
    if [[ -z $1 ]]; then
      echo >&2 "No source image in argument, aborting."
    else
      # Set variables as local so they don't escape in global environment.
      local sizes sizes_all size images
      # Regular sizes (for desktop browsers).
      sizes=(16 24 32 48 64)
      # Add sizes for mobile devices and iterate the whole array.
      sizes_all=("${sizes[@]}" 57 72 114 120 144 152)
      for size in $sizes_all; do
        # Use convert to resize image to given format, the `>` means the operation will fail if the
        # image would have to be stretched (oversized) to fit icon bounds.
        convert "$1" -resize "${size}x${size}!>" "favicon-${size}.png"
        # Add only names which are contained in original `sizes` array.
        if [[ "${sizes[@]}" =~ "$size" ]]; then
          images+=("favicon-${size}.png")
        fi
      done
      # Combine original images into a single favicon.
      convert $images "favicon.ico"
      # Remove origianl images, there's no more use for them.
      rm $images
    fi
  fi
}

# Convert mp3 file(s) into a single .m4b audiobook file.
# Usage: mp3-to-audiobook [-o outfile] infile1 [infile2 [...]]
# If outfile doesn't end in .m4b, it will be added automatically.
# Defaults:
#  - infiles: All *.mp3 files in current working directory.
#  - outfile: {name of current working direcotry}.m4b.
# Notes:
#  - Outfile option (`-o {outfile}`) must be specified before infiles.
#
# Examples:
# (assume we're in folder `test` with `file1.mp3, file2.mp3, file3.mp3`)
#  - mp3-to-audiobook -o audiobook.m4b file1.mp3 file2.mp3 (convert `file1.mp3 + file2.mp3` into `audiobook.m4b`)
#  - mp3-to-audiobook file1.mp3 file2.mp3 (convert `file1.mp3 + file2.mp3` into `test.m4b`)
#  - mp3-to-audiobook -o audiobook.m4b *.mp3 (convert `file1.mp3 + file2.mp3 + file3.mp3` into `audiobook.m4b`)
#  - mp3-to-audiobook (same as `mp3-to-audiobook -o $(basename $PWD) *.mp3`)
#
mp3-to-audiobook () {
  local outfile infiles file len concat title
  # Check for ffmpeg command, exit if ti doesn't exist.
  if ! command -v ffmpeg >/dev/null 2>&1; then
    text="Command 'ffmpeg' is required, please install it.\nIf on OS X, use:\n\n"
    text="${text}brew install ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-libass"
    text="${text} --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265"
    echo -e >&2 "$text"
  else
    # Set default output filename as current directory name.
    outfile=$(basename $PWD)
    # Parse arguments and check for -o (output file) argument.
    OPTIND=1
    while getopts "o" opt; do
      case "$opt" in
        o) outfile=$2 ;;
      esac
    done
    # Shift opts to skip options arguments.
    shift $((OPTIND-1)); [ "$1" = "--" ] && shift

    # If output file doesn't end in .m4b file ext, add it.
    if [[ "$outfile" != "*.m4b" ]]; then
      outfile="${outfile}.m4b"
    fi

    # Set `infiles` to all arguments (except starting -o if it exists).
    infiles="$@"
    # If infiles is empty, then set files to all files in current directory with .mp3 extension.
    if [ -z $infiles ]; then
      infiles=(*.mp3)
    fi

    # Loop through all arguments and concat them into string `"concat:file_1|file_2|...|file_n|"`.
    len=0
    concat="concat:"
    for file in $infiles; do
      concat="${concat}$file|"
      len=$((len + 1))
    done

    # If len is 1, set $infiles as only the ffmpeg input file,
    #   otherwise use concat with remove last `|` character from the string.
    # This is a fix to prevent concatenating files if there is only a single input file.
    [[ "$len" == "1" ]] && concat="$infiles" || concat="${concat%?}"

    # Set title as outfile name w/o file ext.
    title=${outfile%.*}
    # Use `ffmpeg` to transform input .mp3 files into audiobook format.
    ffmpeg -i "$concat" -metadata title="$title" -metadata genre="Audiobook" \
      -c:a libfdk_aac -b:a 64k -f mp4 "$outfile"
  fi
}

# Pull all branches from specified remote (defaults to "origin").
# Usage: git-pull-all [remote]
# Examples:
#  Use origin as remote: git-pull-all
#  Use upstream as remote: git-pull-all upstream
git-pull-all () {
  local remote allowed_remotes remote_branch

  # Get specified remote or default to origin.
  remote="${1:-origin}"

  # List remote-tracking branches, invert grep to match just text (skip colors),
  # then read each branch, regex-match it against allowed_remotes and
  # if it matches, create new branch and tell it to track corresponding remote branch.
  git branch --remotes | grep -v '\->' | while read remote_branch; do
    if [[ $remote_branch =~ "^$remote.*" ]]; then
      git branch --track "${remote_branch#$remote/}" "$remote_branch"
    fi
  done

  echo "Fetching from $remote"
  git fetch "$remote"
}

alias glal=git-pull-all

# load NVM (Node Version Manager) script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

source "$HOME/.iterm2_shell_integration.zsh"
# eval "$(rbenv init -)"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

alias grep="ggrep"

if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info 2>/dev/null)
fi
