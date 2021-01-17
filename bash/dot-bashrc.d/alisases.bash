#!/bin/bash

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# listing files
alias la='ls -lAh'

# shortcuts paths
alias devel='cd ${HOME}/Development'
alias cache='cd ${HOME}/Downloads'

# shortcuts commands
alias c="clear"
alias e='${EDITOR}'
alias se='sudo ${EDITOR}'

# shortcuts for programs
alias code='$(command -v codium)'

# edit bashrc and reload it
alias bashrc='${EDITOR} ${HOME}/.bashrc && source ${HOME}/.bashrc'

# intuitive map function
alias map="xargs -n1"

# print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
