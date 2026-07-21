#
# ls
#

alias ls="ls --color=auto"
alias ll="ls -larth"

#
# grep
#

alias grep="grep --color=auto"

#
# git
#

# (see also: fns.sh for additional git toolin')
alias gcm='git commit -m'
alias gco='git checkout'
alias gpo='git push origin'
alias gst='git status'
alias gpr='git pull --rebase --autostash'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold magenta)<%an>%Creset'"
alias glogg="git --no-pager log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gap="git add -p"
alias gd="git diff"
alias gdt="git difftool"

#
# tmux
#

alias tmn="tmux new -t"
alias tma="tmux a -t"
alias tmls="tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,detached}' | column -t -s '|'"

#
# vim
#

alias vim="nvim"
alias vimdiff='nvim -d'


#
# docker compose
#

alias dc="docker-compose"
alias dcr="docker-compose run --rm"

#
# misc
#

alias zshr="source $ZDOTDIR/.zshrc"

alias editdots="cd ~/dotfiles; nvim"

alias brew:bundle="brew bundle --file ~/.Brewfile"

# parse input json, emit doc structure
# eg: `curl -s 'https://ip-ranges.amazonaws.com/ip-ranges.json' | jq-struct`
alias jq-struct='jq -r '"'"'[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'"'"''

alias weather="curl wttr.in"
