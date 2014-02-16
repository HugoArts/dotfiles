# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


function term_title() {
    echo -ne "\033]0;$*\007"
}

function color() {
    local reset='\e[0m'
    declare -A colors=([black]='\e[0;30m'
                       [red]='\e[0;31m'
                       [green]='\e[0;32m'
                       [yellow]='\e[0;33m'
                       [blue]='\e[0;34m'
                       [magenta]='\e[035m;'
                       [cyan]='\e[0;36m'
                       [white]='\e[0;37m')

    if [[ -z "$1" || -z "$2" ]]; then
        # incorrect number of arguments
        echo "usage: color STRING (COLORNAME | COLORINDEX)"
        return 1
    fi
    if [[ -z "${colors[$2]}" ]]; then
        # it's not in the 16-color hash table. Maybe an index?
        if [[ $2 -gt 256 || $2  -lt 0 ]]; then
            echo "ERROR: unknown color name and not a 256-color index: '$2'"
            return 2
        fi

        echo -ne "\e[38;5;$2m$1${reset}"
        return 0
    fi

    echo -ne "${colors[$2]}$1${reset}"
}

function is_git_dirty {
  git diff --no-ext-diff --quiet --exit-code &> /dev/null || echo "*"
}

function show_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' \
                                           -e "s/* \(.*\)/(\1$(is_git_dirty))/"
}

PS1="[$(color '\u@\h' 203) \\W\$(show_git_branch)]\\$ "
PROMPT_COMMAND='term_title "${USER}@$(hostname): ${PWD/#${HOME}/~}"'
PATH="$PATH:$HOME/bin"
EDITOR="vim"

# history options
HISTCONTROL=ignoredups:ignorespace
HISTIGNORE="&:ls:[bf]g:exit"
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval $(dircolors -b)
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vi='vim'
alias ack='ack-grep'
alias browse-here='nautilus `pwd` &'
alias sl='sl -e'
alias less='less -F'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# code to set 256-color terminal in gnome-terminal.
# From: http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="xterm-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi
