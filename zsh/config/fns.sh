# fn comment format is important! `halp` parses the first line.
#
# template:
# cmd [args] - "mnemonic (optional)" -- what it do.
# cmd() {
#     ...
# }

# tms [session name] - "tmux session" -- attach / switch / create a tmux session.
# - no args: pick a recent session
# - with query arg, pick a match or create it (if no matches).
tms() {
    local change session fzf_status
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"

    session=$(tmux list-sessions -F "#{session_activity}	#{session_name}" 2>/dev/null \
        | sort -rn \
        | cut -f2- \
        | fzf --no-sort --query="$1" --select-1 --exit-0)
    fzf_status=$?
    [[ "$fzf_status" -eq 130 ]] && return 130

    if [[ -n "$session" ]]; then
        tmux $change -t "$session"
    elif [[ -n "$1" ]]; then
        tmux new-session -d -s "$1" && tmux $change -t "$1"
    else
        echo "No sessions found."
        return 1
    fi
}

# gpob [git push args...] - "git push origin <current-branch>" -- Push current branch to origin.
# - Pushes the current branch to origin
# - Passes args through to git push
gpob() {
  local branch
  branch=$(git symbolic-ref --short HEAD)
  git push "$@" origin "$branch"
}

# gcf [--autosquash] [commit-hash] - "git commit --fixup" -- Create a fixup commit.
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


# gcb [-b new-branch] [pattern] - "git checkout branch" -- Check out a local branch via fzf.
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


# gcbr [pattern] - "git checkout branch (remote)" -- Check out a remote branch via fzf.
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

# gdd [git diff args...] [--staged] [--both] [--side] [--horiz] - "git diff delta" -- Browse changed files and preview diffs.
# Examples:
# - gdd                         # unstaged changes
# - gdd -c, gdd --staged        # staged changes
# - gdd -b, gdd --both          # staged and unstaged changes
# - gdd main...HEAD             # branch/range diff
# - gdd path/to/file            # one tracked file
# - gdd -s, gdd --side          # side-by-side preview
# - gdd -h, gdd --horiz         # preview pane on the right
# Keys: ctrl-a stage, ctrl-o open, ctrl-r refresh
gdd() {
    local -a git_args
    local -a fzf_layout_args
    local arg
    local delta_features="${DELTA_FEATURES:-}"
    local layout="vert"
    local preview_window="up,90%,wrap-word"

    for arg in "$@"; do
        case "$arg" in
            -c|--cached|--staged)
                git_args+=(--staged)
                ;;
            -b|--both)
                git_args+=(HEAD)
                ;;
            -s|--side)
                delta_features="${delta_features:+${delta_features} }side-by-side"
                ;;
            -h|--horiz)
                layout="horiz"
                preview_window="right,70%,wrap-word"
                ;;
            *)
                git_args+=("$arg")
                ;;
        esac
    done

    # vert default handling
    if [[ "$layout" == "vert" ]]; then
        # Keep fzf fullscreen, but resize the preview so the file list shows up to 10 matches.
        fzf_layout_args=(
            --sync
            --bind 'start,result,resize:transform:
                list_lines=${FZF_MATCH_COUNT:-${FZF_TOTAL_COUNT:-0}}
                [ "$list_lines" -gt 10 ] && list_lines=10
                preview_lines=$((FZF_LINES - list_lines - 4))
                [ "$preview_lines" -lt 1 ] && preview_lines=1
                printf "change-preview-window(up,%s,wrap-word)" "$preview_lines"'
        )
    fi

    local preview_git_args=""
    local -a list_git_args=("${git_args[@]}")

    # A lone tracked file is a pathspec. Use it to restrict the file list,
    # but keep it out of the preview prefix; preview adds `-- {}` itself.
    if (( ${#git_args[@]} == 1 )) && git ls-files --error-unmatch -- "${git_args[1]}" >/dev/null 2>&1; then
        list_git_args=(-- "${git_args[1]}")
        git_args=()
    fi

    if (( ${#git_args[@]} )); then
        preview_git_args="${(j: :)${(q)git_args}} "
    fi

    local files
    files=$(git diff --color=always --name-only "${list_git_args[@]}")
    if [[ -z "$files" ]]; then
        echo "gdd: no changes to show" >&2
        return 1
    fi

    local list_command="git diff --color=always --name-only"
    if (( ${#list_git_args[@]} )); then
        list_command+=" ${(j: :)${(q)list_git_args}}"
    fi
    list_command+=" || true"

    local stage_bind="ctrl-a:execute-silent(git add -- {+})+reload($list_command)+refresh-preview"
    local open_bind="ctrl-o:execute(\${EDITOR:-vim} {+})+reload($list_command)+refresh-preview"
    local refresh_bind="ctrl-r:reload($list_command)+refresh-preview"

    print -r -- "$files" |
        DELTA_FEATURES="$delta_features" fzf \
            --ansi \
            --height=100% \
            --info-command='printf "\033[33mΔ%s\033[m" "$FZF_TOTAL_COUNT"' \
            --margin=0 \
            --multi \
            --bind "$stage_bind,$open_bind,$refresh_bind" \
            "${fzf_layout_args[@]}" \
            --preview "git diff --color=always ${preview_git_args}-- ':(top)'{} | delta --width=\${FZF_PREVIEW_COLUMNS}" \
            --preview-window="$preview_window" || true
}


# ge [query] - "grep edit" -- Fuzzy search file contents, open match in vim.
ge() {
    local selected file line
    selected=$(fzf \
        --disabled \
        --query="$*" \
        --bind 'start:reload:if [ -n {q} ]; then ag --vimgrep --smart-case -- {q} 2>/dev/null || true; fi' \
        --bind 'change:reload:if [ -n {q} ]; then ag --vimgrep --smart-case -- {q} 2>/dev/null || true; fi' \
        --delimiter : \
        --preview 'bat --color=always --style=numbers --highlight-line {2} {1}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3') || return

    [[ "$selected" =~ '^(.+):([0-9]+):[0-9]+:' ]] || return 1
    file="${match[1]}"
    line="${match[2]}"
    ${EDITOR:-vim} "+$line" "$file"
}


# fe [pattern] - "file edit" -- Fuzzy search filenames, open match in vim.
# Supports fuzzy search with fzf and automatically opens if there's only one match.
fe() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}


# fo [pattern] - "folder open" -- Fuzzy search filders, `open` it.
# Automatically opens the directory if there's only one match.
fo() {
    IFS=$'\n' dir=$(find . -type d -iname "*$1*" 2>/dev/null \
        | fzf --query="$1" --select-1 --exit-0)
    if [[ -n "$dir" ]]; then
        open "$dir"
    fi
}

# cdp [pattern] - "cd projects" -- Jump to a project directory.
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

# cdd [path] - "cd down" -- Change to a selected subdir.
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

# foad [signal] - "foad" - Kill selected processes.
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

# ls_colors [--all] - Preview current theme colors.
function ls_colors() {
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

# halp [pattern] - List custom zsh helpers.
halp() {
    local zsh_dir="${ZDOTDIR:-$HOME/.config/zsh}"
    local width="${COLUMNS:-100}"
    local pattern="$*"
    local reset=$'\033[0m'
    local bold=$'\033[1m'
    local dim=$'\033[2m'
    local cyan=$'\033[36m'
    local green=$'\033[32m'
    local magenta=$'\033[35m'

    {
        printf "%bfunctions%b\n" "$bold$magenta" "$reset"
        awk -F ' - ' -v c="$cyan" -v d="$dim" -v r="$reset" '
            /^# [[:alnum:]_]/ && NF > 1 {
                sig = $1
                desc = $2
                for (i = 3; i <= NF; i++) desc = desc " - " $i
                sub(/^# /, "", sig)

                cmd = sig
                sub(/[[:space:]].*/, "", cmd)
                sub(/\[.*/, "", cmd)
                if (cmd == "cmd" || cmd == "halp") next

                mnemonic = ""
                if (desc ~ / -- /) {
                    n = split(desc, parts, / -- /)
                    mnemonic = parts[1]
                    desc = parts[2]
                    for (i = 3; i <= n; i++) desc = desc " -- " parts[i]
                    gsub(/^"|"$/, "", mnemonic)
                }
                if (mnemonic) mnemonic = "\"" mnemonic "\""

                printf "  %s%-16s%s %s%-45s%s %s%s%s\n", c, cmd, r, d, desc, r, d, mnemonic, r
            }
        ' "$zsh_dir/config/fns.sh"

        printf "\n%baliases%b\n" "$bold$magenta" "$reset"
        awk -v c="$green" -v d="$dim" -v r="$reset" -v width="$width" '
            /^alias [[:alnum:]_:-]+=/ {
                line = $0
                sub(/^alias /, "", line)
                name = line
                sub(/=.*/, "", name)
                cmd = line
                sub(/^[^=]+=/, "", cmd)
                gsub(/^'\''|'\''$/, "", cmd)
                gsub(/^"|"$/, "", cmd)
                if (length(cmd) > width - 22) cmd = substr(cmd, 1, width - 25) "..."
                printf "  %s%-16s%s %s%s%s\n", c, name, r, d, cmd, r
            }
        ' "$zsh_dir/config/aliases.sh"
    } | if [[ -n "$pattern" ]]; then
        grep -iF --color=always -- "$pattern"
    else
        cat
    fi
}


