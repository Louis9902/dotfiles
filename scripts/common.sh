#!/usr/bin/env bash

[[ -n "$DOT_FILES_COMMON_SH" ]] && return
DOT_FILES_COMMON_SH=1

HOST="$(hostname)"
declare -rn HOST=HOSTNAME


[ -n "${DEBUG}" ] && set -x


get_default_user_name() {
	getent passwd "${USER}" | cut -d ':' -f 5
}

get_default_user_mail() {
	echo "${USER}@${HOST}"
}

# @param source
# @param target
install_inks() {
	local source="${1}"; shift
	local target="${1}"; shift
	local file
	for file in "${source}"/*; do
		# only link files
		[[ ! -f "${file}" ]] && continue
		# and don't override non symlinks
		[[ ! -h "${target}/$(basename "${file}")" ]] && continue
		ln -fs "${file}" "${target}"
	done
}

read_input_args() {
	local name="$1"
	name=${name^^}
	name=${name// /_}
	[[ -n "${!name}" ]] && echo "${!name}" && return
	read -r -e -p "$1: " -i "$2" result
	echo -n "${result}"
}

require_system_executable() {
	return
}