#!/bin/bash

# editor for editing files in the terminal
EDITOR="$(command -v nano)"
# editor for editing files in the gui
VISUAL="$(command -v nano)"

export EDITOR VISUAL

# increase bash history size.
HISTSIZE=32768
HISTFILESIZE="$HISTSIZE"
# omit duplicates and commands that begin with a space from history.
HISTCONTROL="erasedups:ignoredups:ignorespace"
# omit some commands from history
HISTIGNORE="&:ls:rm:[bf]g:exit:pwd:clear:mount:umount:cd:* --help:* -h:[ \t]*"

export HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE

#export STACK_ROOT="$XDG_DATA_HOME"/stack
