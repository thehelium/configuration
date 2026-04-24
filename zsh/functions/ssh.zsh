ssh() {
  # Extract target hostname (last non-option argument)
  local host=""
  for arg in "$@"; do
    [[ "$arg" != -* ]] && host="$arg"
  done

  if [[ -n "$TMUX" && -n "$host" ]]; then
    tmux rename-window "$host"
    command ssh "$@"
    tmux rename-window "$(basename "$SHELL")"
  else
    command ssh "$@"
  fi
}
