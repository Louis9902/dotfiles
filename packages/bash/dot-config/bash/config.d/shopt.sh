#!/usr/bin/env bash

# update window size after every command
shopt -s checkwinsize

# automatically trim long paths in
# the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# perform file completion in a case
# insensitive fashion
bind "set completion-ignore-case on"
# treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# display matches for ambiguous patterns
# at first tab press
bind "set show-all-if-ambiguous on"
# immediately add a trailing slash when
# autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null


# This defines where cd looks for targets
# Add the directories you want to have fast access to,
# separated by colon Example: CDPATH=".:~:~/projects"
# will look for targets in the current working
# directory, in home and in the ~/project
CDPATH=".:${HOME}"

# This allows you to bookmark your favorite
# places across the file system. Define a variable
# containing a path and you will be able to cd
# into it regardless of the directory you're in
shopt -s cdable_vars

# ➜