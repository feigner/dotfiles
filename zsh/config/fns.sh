# tm [session name] - Create or switch to a tmux session.
# If inside tmux, switches to the specified session or creates it if it doesn't exist.
# If no session name is provided, select a session using fzf.
tm() {
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    if [[ $1 ]]; then
        tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s "$1" && tmux $change -t "$1")
        return
    fi
    local session
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null \
        | fzf --exit-0) && tmux $change -t "$session" || echo "No sessions found."
}

# tms [pattern] - Switch to a tmux session via fzf.
# Automatically selects a session if there's only one match.
tms() {
    local session
    session=$(tmux list-sessions -F "#{session_name}" \
        | fzf --query="$1" --select-1 --exit-0) &&
        tmux switch-client -t "$session"
}


# gcb [pattern] - "git checkout branch"
# - Shows a list of branches if no arguments are provided.
# - Filters branches using the provided pattern.
# - Automatically checks out if there's an exact match.
gcb() {
    local branch
    branch=$(git branch --sort=-committerdate --format='%(refname:short)' \
        | fzf --query="$1" --select-1 --exit-0)

    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}


# fe [pattern] - "file edit" -- Open the selected file with the default editor.
# Supports fuzzy search with fzf and automatically opens if there's only one match.
fe() {
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}


# fo [pattern] - "folder open" -- list directories and open the selected one.
# Automatically opens the directory if there's only one match.
fo() {
    IFS=$'\n' dir=$(find . -type d -iname "*$1*" 2>/dev/null \
        | fzf --query="$1" --select-1 --exit-0)
    if [[ -n "$dir" ]]; then
        open "$dir"
    fi
}

# cdp [pattern] - "cd projects" -- Change to projects dir
# If no argument is provided, change to $PROJECT_DIR
# If a pattern is provided, filter directories in $PROJECTS_DIR using fzf.
# Automatic selection if there's only one match.
cdp() {
    local projects_dir="${PROJECTS_DIR}"
    if [[ -z "$1" ]]; then
        cd "$projects_dir" || return
    else
        local selected
        selected=$(find "$projects_dir" -maxdepth 1 -type d -iname "*$1*" -exec basename {} \; \
            | fzf --select-1 --exit-0 --preview "tree -C '$projects_dir/{}' | head -100")
        if [[ -n "$selected" ]]; then
            cd "$projects_dir/$selected" || return
        fi
    fi
}

# cdd [path] - "cd down" -- Change to a selected subdirectory including hidden ones.
cdd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf --query="$1" --select-1 --exit-0) && cd "$dir"
}

# cdu [path] - "cd up" -- Change to a selected parent directory.
cdu() {
    parents=()
    current_dir=$(dirname "$PWD")
    while [[ $current_dir != "/" ]]; do
      parents+=("$current_dir")
      current_dir=$(dirname "$current_dir")
    done
    parents+=("/")
    dir=$(printf "%s\n" "${parents[@]}" | fzf --query="$1" --select-1 --exit-0)
    [[ -n "$dir" ]] && cd "$dir"
}

# foad [signal] - Kill selected processes.
# Displays processes in fzf for selection and sends the specified signal (default: SIGKILL).
foad() {
    local pid
    if [[ "$UID" != "0" ]]; then
        pid=$(ps -f -u "$UID" | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -"${1:-9}"
}

# list_colors [--all] - theme color helper
function list_colors() {
  local range
  if [[ "$1" == "--all" ]]; then
    range=({0..255})
  else
    range=({0..15})
  fi
  for i in "${range[@]}"; do
    printf "%3s: \x1b[38;5;${i}m██████████ Wu-Tang is for the children.\x1b[0m\n" "${i} "
  done
}
