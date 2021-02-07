#!/bin/bash

path-contains() {
	echo "$PATH" | grep -E -q "(^|:)$1($|:)"
}

path-with-suffix() {
	if [[ ! -e "$1" ]] || path-contains "$1"; then
		return
	fi
	PATH="$PATH:$1"
}

path-with-prefix() {
	if [[ ! -e "$1" ]] || path-contains "$1"; then
		return
	fi
	PATH="$1:$PATH"
}

path-with-suffix "${HOME}/.local/bin"
path-with-suffix "${GOPATH:-$HOME/go}/bin"

# export path so it is visible for sub-shells
export PATH

# cleanup
unset -f path-contains path-with-suffix path-with-prefix
