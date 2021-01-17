#!/bin/bash

# miscellaneous
shopt -s cmdhist      # store multiline commands as 1 line
shopt -s checkwinsize # check the window size after each command
shopt -s histappend   # append each history entry from all terminals realtime
shopt -s histverify   # write command completion history in read line buffer

# completion
shopt -s cdspell                 # fixes minor spelling errors in cd paths
shopt -s autocd 2>/dev/null      # can change dir without `cd`
shopt -s dirspell 2>/dev/null    # completion can fix dir name typos
shopt -s no_empty_cmd_completion # stops empty line completion
