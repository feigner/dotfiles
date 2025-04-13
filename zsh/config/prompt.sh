# C O M P U T R O N prompt
# features:
#   _ sweettart colors
#   _ chop cwd to 45 chars
#   _ show git branch w/ dirty git indicator

purp=$FG[097]
white=$FG[253]
dark_grey=$FG[238]
light_grey=$FG[241]
light_grey_bg=$BG[241]
dark_grey_bg=$BG[238]
bold="%B"
reset="%f%b"
reset_bg="%k"

# maybe I'm doing something wrong, but startup times using zsh's `vcs_info`
# to get branch / dirty status is higher than just doing it the ol' fashioned way :thunk:
git_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch dirty
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
      dirty=$(git status --porcelain --untracked-files=no 2>/dev/null)
      echo -n "${bold}${dark_grey}${dark_grey_bg}${fg[yellow]}${branch}${dirty:+${fg[red]}✱}${reset_bg}${dark_grey}${reset}"
    fi
  fi
}

# precmd for dynamic git_info
# NOTE: esc with %{} to avoid zsh prompt width calcs from
# going berzerk and eating into scrollback buffer
precmd() {
PROMPT="
${bold}%{$fg[blue]%}%n\
${purp}@\
%{$fg[green]%}%m\
%{$fg[white]%}:\
${bold}%{$fg[white]%}%45<...<%~%<<${reset} \
$(git_info)
${bold}${purp}❯ ${reset}"
}

# see `vim-mode` for rprompt tweakin'
RPROMPT=""
