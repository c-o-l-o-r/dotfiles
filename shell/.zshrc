# ZSH configuration
export PROMPT="%~ $ "

# History (https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# vim mode (https://dougblack.io/words/zsh-vi-mode.html)
bindkey -v
bindkey -M viins '^J' vi-cmd-mode

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# search history with up & down keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search # Up
bindkey "^N" down-line-or-beginning-search # Down

bindkey -s "^[[A" "\a"
bindkey -s "^[[B" "\a"

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

if command -v nvim > /dev/null; then
	alias vim=nvim
	alias vi=nvim
fi

# rust config
export PATH="$HOME/.cargo/bin:$PATH"

# preserve current environment when sudoing
alias sudo='sudo -E'

if command -v exa > /dev/null; then
	alias l='exa'
	alias ll='exa'
	alias ll='exa -l'
	alias la='exa -lag'
else
	alias l='ls'
	alias ll='ls'
	alias ll='ls -l'
	alias la='ls -la'
fi

# constants
export HISTORY_IGNORE="(l|ls|ll|la|cd|pwd|exit|cd ..)"
export EDITOR="nvim"
export PATH=$HOME/.bin:$PATH
export DEV_WORKSPACE=~/development

# set gpg agent
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
# echo UPDATESTARTUPTTY | gpg-connect-agent >> /dev/null

# allows time for 'kj' to exit insert in vim-mode
export KEYTIMEOUT=20

# golang config
export GOPATH=$DEV_WORKSPACE/go-workspace # don't forget to change your path correctly!
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin

# pyenv config
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# nvm config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v rg > /dev/null; then
  export FZF_DEFAULT_COMMAND=$'rg --files --hidden --glob '!.git''
fi

eval "$(starship init zsh)"
