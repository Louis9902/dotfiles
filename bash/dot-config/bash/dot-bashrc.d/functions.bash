#!/bin/bash

# Create a short git.io url with a custom code
git-io() {
	if [ -z "${1}" ] || [ -z "${2}" ]; then
		echo "Usage: git-io slug url"
		return 1
	fi
	curl -i https://git.io -F "url=${2}" -F "code=${1}"
}

# Extract common archive files
extract() {
	echo "Extracting $1 ..."
	if [ -f "$1" ]; then
		case "$1" in
		*.tar.bz2) tar xjf "$1" ;;
		*.tar.gz) tar xzf "$1" ;;
		*.bz2) bunzip2 "$1" ;;
		*.rar) rar x "$1" ;;
		*.gz) gunzip "$1" ;;
		*.tar) tar xf "$1" ;;
		*.tbz2) tar xjf "$1" ;;
		*.tgz) tar xzf "$1" ;;
		*.zip) unzip "$1" ;;
		*.Z) uncompress "$1" ;;
		*.7z) 7z x "$1" ;;
		*.xz) xz -d "$1" ;;
		*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Colorize man pages with less
man() {
	env \
		LESS_TERMCAP_mb="$(printf "\e[01;31m")" \
		LESS_TERMCAP_md="$(printf "\e[01;38;5;74m")" \
		LESS_TERMCAP_me="$(printf "\e[0m")" \
		LESS_TERMCAP_se="$(printf "\e[0m")" \
		LESS_TERMCAP_so="$(printf "\e[38;5;246m")" \
		LESS_TERMCAP_ue="$(printf "\e[0m")" \
		LESS_TERMCAP_us="$(printf "\e[04;38;5;146m")" \
		man "$@"
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
o() {
	if [ $# -eq 0 ]; then
		xdg-open .	> /dev/null 2>&1
	else
		xdg-open "$@" > /dev/null 2>&1
	fi
}

# make a backup of a file
backup() { cp "$1"{,.bkp}; }

mkcd() { mkdir -p "$1" && cd "$1" || return; }

monitor-off() { xrandr --output HDMI-1 --off; }
monitor-on() { xrandr --output HDMI-1 --auto --left-of HDMI-2; }
