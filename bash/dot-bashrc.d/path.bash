#!/bin/bash

path-has() {
	echo "$PATH" | grep -E -q "(^|:)$1($|:)"
}

path-add() {
	if [[ ! -e "$1" ]] || path-has "$1"; then
		return
	fi

	if [[ "$2" = 'suffix' ]]; then
		PATH="$PATH:$1"
	elif [[ "$2" = 'prefix' ]]; then
		PATH="$1:$PATH"
	else
		exit 1
	fi

}

path-add "${HOME}/.local/bin" suffix
path-add "${GOPATH:-$HOME/go}/bin" suffix

export PATH

# cleanup
unset -f path-has path-add
