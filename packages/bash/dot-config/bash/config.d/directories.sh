#!/usr/bin/env bash

# common functions for working with directories

# ---------------------------------------------
# shortcuts for moving around
# ---------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ---------------------------------------------
# shortcuts for creating and removing folders
# ---------------------------------------------
alias md='mkdir -p'
alias rd='rmdir'


# ---------------------------------------------
# more shortcuts for listing files
# ---------------------------------------------
alias ls='ls --color=auto'
alias la='ls --color=auto -Alh'	# show hidden files
alias ll='ls --color=auto -lh'	# sort by size human readable
alias lr='ls --color=auto -lR'	# recursive ls
alias lt='ls --color=auto -ltr'	# sort by date

# ---------------------------------------------
# shortcuts for showing human-readable fs info
# ---------------------------------------------

# short and human-readable file listing
alias dud='du -d 1 -h'
# short and human-readable directory listing
alias duf='du -sh *'
