#!/usr/bin/env bash

## command history configuration
if [ -z "$HISTFILE" ]; then
  HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/bash/.history
fi

# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

# use readline on history
shopt -s histreedit

# load history line onto readline buffer for editing
shopt -s histverify

# save history with newlines instead of ; where possible
shopt -s lithist

# record each line as it gets issued
# PROMPT_COMMAND='history -a'

# huge hostory file
HISTSIZE=500000
HISTFILESIZE=100000

# omit duplicates and commands that begin with a space from history
HISTCONTROL="erasedups:ignoredups:ignorespace"

# don't record some commands
export HISTIGNORE="&:ls:rm:[bf]g:exit:pwd:clear:history:cd:* --help:* -h:[ \t]*"

# use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# enable incremental history search with up/down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
