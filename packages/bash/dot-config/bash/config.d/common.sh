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

export EDITOR VISUAL

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
alias se='sudoedit'

# src: reload .bashrc file
alias src='source ~/.bashrc'

# qfind: quickly search for file
alias qfind='find . -name '

# ip just color my ip command
alias ip='ip -c'


# ---------------------------------------------
# setup some shortcuts for applications
# and a preferred default implementation
# ---------------------------------------------

# 'wget' with resume download
alias wget='wget -c --no-hsts'

# just use color, please
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'
alias xzgrep='xzgrep --color=auto'
alias zegrep='zegrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zgrep='zgrep --color=auto'


# ---------------------------------------------
# setup some alias shortcuts for applications
# ---------------------------------------------

if command -v codium >/dev/null; then
	code() { { test $# -gt 0 && command codium "$@"; } || command codium .; }
else
	alias code='e'
fi

LESSHISTFILE=/dev/null
export LESSHISTFILE
