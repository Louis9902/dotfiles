#!/bin/bash

main() {
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

	export PATH
}

main "$@"
