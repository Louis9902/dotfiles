#!/usr/bin/env bash
# shellcheck disable=SC2059,SC2086

[[ -n "$DOT_FILES_MESSAGE_SH" ]] && return
DOT_FILES_MESSAGE_SH=1

_format() {
	local prompt="${1}"; shift
	local format="${1}"; shift
	printf " $(tput bold)[$(tput sgr0) ${prompt} $(tput bold)]$(tput sgr0) ${format}\n" $* >&1
}

warn() { _format "$(tput setaf 003)WARN$(tput sgr0)" "$@"; }
info() { _format "$(tput setaf 006)INFO$(tput sgr0)" "$@"; }