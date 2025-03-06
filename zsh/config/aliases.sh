#
# aliases
#


# ls
alias ls="ls --color=auto"
alias ll="ls -larth"

# grep
alias grep="grep --color=auto"

# git
alias gst='git status'
alias gpr='git pull --rebase'
alias gprs='git pull --rebase --autostash'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold magenta)<%an>%Creset'"
alias glogg="git --no-pager log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

# vim
alias vim="nvim"
alias vimdiff='nvim -d'

# zsh
alias zsh:reload="source $ZDOTDIR/.zshrc"
alias zsh:edit="nvim $ZDOTDIR/.zshrc"
alias zsh:alias="less ~/.config/zsh/config/aliases.sh"
alias zsh:alias:edit="nvim ~/.config/zsh/config/aliases.sh"

# tmux
alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"

# homebrew
alias brew:bundle="brew bundle --file ~/.Brewfile"

# Docker Compose
alias dc="docker-compose"
alias dcr="docker-compose run --rm"

# misc
alias editdots="cd ~/dotfiles; nvim"
alias weather="curl wttr.in"
