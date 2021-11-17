#!/usr/bin/env bash
# shellcheck disable=SC1090
DOT_FILES_DIR="$(dirname "$(realpath "$0")")"
declare -xr DOT_FILES_DIR

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

export info warn require_system_executable read_input_args
export get_default_user_name get_default_user_mail

install_package() {
	local name="$1"; shift
	local root="${DOT_FILES_DIR}/packages/${name}"
	if [[ -z "${name}" || ! -d "${root}" ]]; then
		warn "The package %s does not exists" "${name}"
		return
	fi
	# install script is no executable
	if [[ ! -x "${root}/install.sh" ]]; then
		chmod u+x "${root}/install.sh"
	fi
	info "Installing %s" "${name}"
	"${root}/install.sh"
}

run() {
	local args
	while [[ $# -gt 0 ]]; do
		args="$1"; shift
		case "${args}" in
			install)
				local package
				while [[ $# -gt 0 ]]; do
					package="$1"; shift
					install_package "${package}"
				done
			;;
		esac
	done
}

# shellcheck disable=SC2068
run $@