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

# gpob [-f|--force] - "git push origin <current-branch> [--force]"
# - Pushes the current branch to origin
# - Pass -f or --force to force push
gpob() {
  local branch
  branch=$(git symbolic-ref --short HEAD)
  if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    git push --force origin "$branch"
  else
    git push origin "$branch"
  fi
}

# gcf [-a|--autosquash] [commit-ish] - "git commit --fixup" with optional autosquash rebase.
# - If no commit is provided, select one from recent history with fzf.
# - Pass -a or --autosquash to immediately run `git rebase -i --autosquash`.
gcf() {
  local autosquash=
  local target
  local line

  [[ "$1" == "-a" || "$1" == "--autosquash" ]] && autosquash=1 && shift

  if [[ -n "$1" ]]; then
    target="$1"
  else
    command -v fzf >/dev/null 2>&1 || {
      echo "usage: gcf [-a|--autosquash] <commit-ish>"
      return 1
    }
    line="$(git log --oneline -n 100 | fzf --no-sort --reverse --prompt='fixup target> ')" || return 1
    target="${line%% *}"
  fi

  git commit --fixup "$target" || return 1

  [[ -n "$autosquash" ]] || return 0
  GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash --autostash "$(git rev-parse "${target}^" 2>/dev/null || echo --root)"
}


# gcb [-b new-branch] [pattern] - "git checkout branch"
# - Shows a list of local branches if no arguments are provided.
# - Filters branches using the provided pattern (substring, not fuzzy via --exact)
# - Automatically checks out if there's an exact match.
# - If '-b new-branch' is passed, creates and checks out a new branch.
gcb() {
    if [[ "$1" == "-b" && -n "$2" ]]; then
        git checkout -b "$2"
        return
    fi

    local branch
    branch=$(git branch --sort=-committerdate --format='%(refname:short)' \
        | fzf --exact --query="$1" --select-1 --exit-0)

    if [[ -n "$branch" ]]; then
        git checkout "$branch"
    fi
}


# gcbr [pattern] - "git checkout branch (remote)"
# - Lists remote branches
# - Filters using provided pattern (substring, not fuzzy via --exact)
# - Creates local tracking branch if selected
gcbr() {
    git fetch
    local branch
    branch=$(git branch -r --sort=-committerdate --format='%(refname:short)' \
        | grep -v '^origin/HEAD$' \
        | fzf --exact --query="$1" --select-1 --exit-0)

    if [[ -n "$branch" ]]; then
        local local_branch=${branch#origin/}
        git checkout -b "$local_branch" --track "$branch"
    fi
}

# gd [git diff args...] [--side] [--vert] [--difft|--delta]
# Browse changed files in fzf and preview the selected diff.
# Examples:
# - gd                         # unstaged changes, delta preview
# - gd --cached                # staged changes
# - gd main...HEAD             # branch/range diff
# - gd path/to/file            # one tracked file
# - gd --side --difft          # difftastic side-by-side preview
# - gd --vert                  # preview stacked above the file list (narrow terminals)
gd() {
    local -a git_args
    local arg
    local renderer="delta"
    local delta_features="${DELTA_FEATURES:-}"
    local difft_display="inline"
    local difft_cmd
    local preview_position="right"
    local preview_size="70%"

    for arg in "$@"; do
        case "$arg" in
            --side)
                delta_features="${delta_features:+${delta_features} }side-by-side"
                difft_display="side-by-side-show-both"
                ;;
            --vert)
                preview_position="up"
                preview_size="90%"
                ;;
            --difft|--difftastic)
                renderer="difft"
                ;;
            --delta)
                renderer="delta"
                ;;
            *)
                git_args+=("$arg")
                ;;
        esac
    done

    local git_args_quoted=""
    local preview_git_args=""
    local preview_cmd=""
    local -a list_git_args=("${git_args[@]}")

    # A lone tracked file is a pathspec. Use it to restrict the file list,
    # but keep it out of the preview prefix; preview adds `-- {-1}` itself.
    if (( ${#git_args[@]} == 1 )) && git ls-files --error-unmatch -- "${git_args[1]}" >/dev/null 2>&1; then
        list_git_args=(-- "${git_args[1]}")
        git_args=()
    fi

    if (( ${#git_args[@]} )); then
        git_args_quoted="${(j: :)${(q)git_args}}"
        preview_git_args="${git_args_quoted} "
    fi

    if [[ "$renderer" == "difft" ]]; then
        if command -v difft >/dev/null 2>&1; then
            difft_cmd="difft"
        elif command -v difftastic >/dev/null 2>&1; then
            difft_cmd="difftastic"
        else
            echo "gd: difftastic not found (expected \`difft\` or \`difftastic\` on PATH)"
            return 1
        fi
        preview_cmd="DFT_COLOR=always DFT_DISPLAY=${difft_display} DFT_WIDTH=\${FZF_PREVIEW_COLUMNS} git -c diff.external=${(q)difft_cmd} diff ${preview_git_args}-- ':(top)'{-1}"
    else
        preview_cmd="git diff --color=always ${preview_git_args}-- ':(top)'{-1} | delta --width=\${FZF_PREVIEW_COLUMNS}"
    fi

    git diff --color=always --name-only "${list_git_args[@]}" |
        DELTA_FEATURES="$delta_features" fzf \
            --ansi \
            --height=100% \
            --margin=0 \
            --preview "$preview_cmd" \
            --preview-window="${preview_position},${preview_size},wrap-word" || true
}

# gdd [git diff args...] [--side] - gd with difftastic previews.
gdd() {
    gd --difft "$@"
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
# If a pattern is provided, filter directories in $PROJECTS_DIR using fzf (--exact for substr, not fuzzy).
# Automatic selection if there's only one match.
cdp() {
    local projects_dir="${PROJECTS_DIR}"
    if [[ -z "$1" ]]; then
        cd "$projects_dir" || return
    else
        local selected
        selected=$(find "$projects_dir" -maxdepth 1 -type d -iname "*$1*" -exec basename {} \; \
            | fzf --exact --select-1 --exit-0 --preview "tree -C '$projects_dir/{}' | head -100")
        if [[ -n "$selected" ]]; then
            cd "$projects_dir/$selected" || return
        else
            echo "no matches"
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
