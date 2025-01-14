## C O M P U T R O N prompt
# features:
#   _ sweettart colors
#   _ chop cwd to 45 chars
#   _ show git branch w/ dirty git indicator

purp=$FG[097]
white=$FG[253]
dark_grey=$FG[238]
bold="%B"
reset="%{%f%}"

# maybe I'm doing something wrong, but startup times using zsh's `vcs_info`
# to get branch / dirty status is higher than just doing it the ol' fashioned way :thunk:
git_info() {
  local branch dirty
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    dirty=$(git status --porcelain --untracked-files=no 2>/dev/null)
    if [[ -n $branch ]]; then
      # Parentheses are bold gray, branch name is yellow, and dirty state is red if set
      echo -n "${fg_bold[grey]}(${fg_bold[yellow]}${branch}${dirty:+${fg[red]}✱}${fg_bold[grey]})${reset}"
    fi
  fi
}

#precmd for dynamic git_info
precmd() {
PROMPT="
${bold}${purp}[\
${fg[blue]}%n\
${purp}@\
${fg[green]}%m\
${fg[white]}:\
${bold}${fg[white]}%45<...<%~%<<${reset}\
${bold}${purp}]${reset} \
$(git_info)
${bold}${purp}󰅂 ${reset}"
}

RPROMPT="${dark_grey}%D{%H:%M:%S}${reset}"
