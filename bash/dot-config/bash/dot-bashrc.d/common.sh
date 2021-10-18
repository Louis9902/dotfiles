#!/usr/bin/env bash

# ---------------------------------------------
# set the default editor for editing
# files in the terminal and in the gui
# ---------------------------------------------

if command -v vim >/dev/null; then
	EDITOR="$(command -v vim)"
	VISUAL="$(command -v vim)"
elif command -v nvim >/dev/null; then
	EDITOR="$(command -v nvim)"
	VISUAL="$(command -v nvim)"
elif command -v nano >/dev/null; then
	EDITOR="$(command -v nano)"
	VISUAL="$(command -v nano)"
elif command -v vi >/dev/null; then
	EDITOR="$(command -v vi)"
	VISUAL="$(command -v vi)"
fi

# ---------------------------------------------
# setup some common shortcuts for fast typing
# ---------------------------------------------

# path: echo all executable paths
alias path='echo -e ${PATH//:/\\n}'

# c: clear terminal display
alias c='clear'

# e: editd file in default editor
alias e='${EDITOR}'
# se: editd file in default editor with sudo rigths
alias se='sudo ${EDITOR}'

# src: reload .bashrc file
alias src='source ~/.bashrc'

# qfind: quickly search for file
alias qfind='find . -name '

# ---------------------------------------------
# setup some shortcuts for applications
# and a preferred default implementation
# ---------------------------------------------

# 'wget' with resume download
alias wget='wget -c --no-hsts'

# ---------------------------------------------
# setup some alias shortcuts for applications
# ---------------------------------------------

if command -v codium >/dev/null; then
	alias code='$(command -v codium)'
else
	alias code='e'
fi

if command -v vim >/dev/null; then
	alias vim=nvim
fi


# redirect go paths to xdg paths
GOBIN="${XDG_BIN_HOME:-$HOME/.local/bin}"
GOMODCACHE="${XDG_STATE_HOME:-$HOME/.local/state}/go/pkg/mod"

export GOBIN GOMODCACHE

PYLINTHOME="${XDG_CACHE_HOME:-$HOME/.cache}/pylint"

export PYLINTHOME

#export STACK_ROOT="$XDG_DATA_HOME"/stack
