function git-open {
  # Open current repository remote in browser.
  # Requires `xdg-open` command to open the url in browser

  # Display error message if not located in git repository.
  if ! $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
      >&2 echo "Not in git repository. Aborting."
      return 1
  fi

  function url_action {
      local url=$1
      if [[ -n $print ]]; then
          echo $url
      else
          xdg-open $url > /dev/null
      fi
  }

  # Get first argument or use default of 'origin'.
  local remote=${1:-origin}
  if [[ $remote != "origin" ]]; then
    echo "Using remote '$remote'"
  fi
  # get push url for remote (pipe to sed is used to fix SSH urls)
  local match_url=$(git remote get-url --push $remote | sed -e 's/git@//' | sed -e 's/\.git$//' | sed -Ee 's/(\..+):/\1\//')
  # If match was successfuly set, perform url_action, otherwise output an error message.
  # Make request to matching url, find last location and trim trailing spaces.
  local resolved_url=$(curl -sLI "$match_url" | grep 'Location:' | cut -d' ' -f2 | tail -1 | sed -e 's/[[:space:]]*$//')
  # if resolved_url not found, fall back to match_url
  if [[ -z "$resolved_url" ]]; then
      resolved_url="$match_url"
  fi

  if [[ -n "$resolved_url" ]]; then
      current_branch=$(git rev-parse --abbrev-ref HEAD)
      if [[ -n "$current_branch" ]]; then
          url_action "$resolved_url/tree/$current_branch"
      else
          url_action "$resolved_url"
      fi
  else
      >&2 echo "No match for remote '$remote'."
  fi
}
