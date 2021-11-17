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
alias la='ls -Alh'	# show hidden files
alias ll='ls -lh'	# sort by size human readable
alias lr='ls -lR'	# recursive ls
alias lt='ls -ltr'	# sort by date

# ---------------------------------------------
# shortcuts for showing human-readable fs info
# ---------------------------------------------

# short and human-readable file listing
alias dud='du -d 1 -h'
# short and human-readable directory listing
alias duf='du -sh *'
