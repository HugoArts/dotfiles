# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# color reset
creset='\e[0m'
# 16 named colors
declare -A ncolors=([black]='\e[0;30m' [red]='\e[0;31m'
                    [green]='\e[0;32m' [yellow]='\e[0;33m'
                    [blue]='\e[0;34m'  [magenta]='\e[035m;'
                    [cyan]='\e[0;36m'  [white]='\e[0;37m')
# 256 colors
for i in $(seq 0 255); do
    colors[$i]="\e[38;5;${i}m"
done


git_dirtycolor() {
    opts="--no-ext-diff --quiet"
    if git diff $opts 2>/dev/null && git diff --cached $opts 2>/dev/null
        then echo 'cyan'
        else echo 'yellow'
    fi
}

git_showbranch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' \
                                             -e "s/* \(.*\)/ (\1)/"
}

set_dollar_color() {
    # color '$' based on exit status
    if [[ "$1" -eq 0 ]]; then
        dollar="\$"
    else
        dollar="${ncolors["red"]}\$$creset"
    fi
}

term_title() {
    echo -ne "\033]0;$*\007"
}

term_prompt() {
    set_dollar_color $?
    term_title "${USER}@$(hostname): ${PWD/#${HOME}/~}"
    dirty=$(git_dirtycolor)
    export PS1="[\[${colors[1]}\]\u@\h\[$creset\] \W\[${ncolors[$dirty]}\]$(git_showbranch)\[$creset\]]$dollar "

    # add virtualenv info if present
    if [[ -n "$VIRTUAL_ENV" ]]; then
        export PS1="($(basename "$VIRTUAL_ENV"))$PS1"
    fi
}

init_virtualenv() {
    if [[ -d ~/python/envs ]]; then
        # get virtualenvwrapper's ass in here
        export VIRTUALENVWRAPPER_PYTHON="$1"
        export WORKON_HOME=~/python/envs
        export PROJECT_HOME=~/python

        if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
            # oooh, a global install. cool
            source /usr/bin/virtualenvwrapper.sh
        elif [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
            # really dude, you gotta put your shit in /usr/local? fine, whatever
            source /usr/local/bin/virtualenvwrapper.sh
        elif [[ -f ~/python/envs/master/bin/virtualenvwrapper.sh ]]; then
            # a locally bootstrapped virtualenv? no problem
            export VIRTUALENVWRAPPER_PYTHON=~/python/envs/master/bin/python
            source ~/python/envs/master/bin/virtualenvwrapper.sh
        fi
    fi
}

# from https://github.com/driv/upto/blob/master/upto.sh
function upto() {
    local EXPRESSION="$1"
    if [ -z "$EXPRESSION" ]; then
        echo "A folder expression must be provided." >&2
        return 1
    fi
    if [ "$EXPRESSION" = "/" ]; then
        cd "/"
        return 0
    fi
    local CURRENT_FOLDER="$(pwd)"
    local MATCHED_DIR=""
    local MATCHING=true

    while [ "$MATCHING" = true ]; do
        if [[ "$CURRENT_FOLDER" =~ "$EXPRESSION" ]]; then
            MATCHED_DIR="$CURRENT_FOLDER"
            CURRENT_FOLDER=$(dirname "$CURRENT_FOLDER")
        else
            MATCHING=false
        fi
    done
    if [ -n "$MATCHED_DIR" ]; then
        cd "$MATCHED_DIR"
        return 0
    else
        echo "No Match." >&2
        return 1
    fi
}

# complete upto
_upto () {
    # necessary locals for _init_completion
    local cur prev words cword
    _init_completion || return

    COMPREPLY+=( $( compgen -W "$( echo ${PWD//\// } )" -- $cur ) )
}
complete -F _upto upto


export PROMPT_COMMAND='term_prompt'
export PATH="$PATH:$HOME/bin"
export EDITOR="vim"

# history options
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTSIZE=1000
export HISTFILESIZE=2000

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize


# some ls aliases
if [ `uname -s` != "Darwin" ]; then
    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        eval $(dircolors -b)
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

if [ `uname -s` = "Darwin" ]; then
    if [[ $ITERM_PROFILE = "light" ]]; then
        export BACKGROUND="light"
    else
        export BACKGROUND="dark"
    fi
    source "$HOME/hugo/dotfiles/base16-default.$BACKGROUND.sh"

    export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    alias ls='ls --color=auto --group-directories-first'
    alias ag="echo use rg!!!"
    alias vim="/usr/local/Cellar/vim/8.0.1050/bin/vim"
    source "`brew --prefix`/etc/bash_completion.d/git-completion.bash"
fi

alias vi='vim'
alias browse-here='nautilus `pwd` &'
alias sl='sl -e'
alias less='less -F'
if $(which ack-grep &> /dev/null); then
    alias ack='ack-grep'
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
