# some config base locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# more dotfile locations
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonstartup.py"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

export HISTFILE="$XDG_STATE_HOME/bash_history"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

init_homebrew() {
    # Set PATH, MANPATH, etc., for Homebrew.
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # put coreutils in the path
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

    # add bash completions from homebrew
    if type brew &>/dev/null
    then
      HOMEBREW_PREFIX="$(brew --prefix)"
      if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
      then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
      else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
        do
          [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
      fi
    fi
}

init_pyenv() {
    if command -v pyenv >/dev/null; then
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
    fi
}

init_cargo() {
    if [[ -e $CARGO_HOME ]]; then
        source "$CARGO_HOME/env"
    fi
}

init_nvm() {
    [ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
}

if [[ $(uname -s) = "Darwin" ]]; then
    export PATH="$PATH:/usr/local/bin"
    init_homebrew
    init_nvm
fi

init_pyenv
init_cargo

# history options
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTSIZE=1000
export HISTFILESIZE=10000

shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

# path and prompt
export PATH="$HOME/.local/bin:$PATH"
export PS1='$(prompt.py "$?" "\u@\h" "\W")'

# some aliases
alias ls="ls --color=auto --group-directories-first"
alias activate="source ./venv/bin/activate"
alias vim="nvim"
