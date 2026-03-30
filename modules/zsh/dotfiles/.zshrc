#!/bin/zsh
# zsh startup time profiling (also uncomment at end of file)
# zmodload zsh/zprof

test "$TERM" = "dumb" && unsetopt zle && export PS1="$ " && return

export GPG_TTY=$(tty)

# Load in look config, aliases and local config
test -f ~/.config/zsh/lookrc && source ~/.config/zsh/lookrc
test -f ~/.config/zsh/keyrc && source ~/.config/zsh/keyrc
test -f ~/.config/zsh/toolrc && source ~/.config/zsh/toolrc
test -f ~/.config/shell/profile && source ~/.config/shell/profile
test -f ~/.config/shell/aliasrc && source ~/.config/shell/aliasrc
test -f ~/.config/shell/localrc && source ~/.config/shell/localrc

setopt sharehistory
HISTSIZE=5000
HISTFILE=~/.cache/.zsh_history
SAVEHIST=100000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

autoload -Uz compinit

precmd() {
    unset -f precmd
    compinit -C -d ~/.cache/zcompdump
    zstyle ':completion:*' completer _extensions _complete _approximate
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
    zstyle ':completion:*' menu select
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
}

# zsh profiling
# zprof
