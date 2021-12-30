#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${XDG_CONFIG_HOME:-"${HOME}/.config"}/bash"

# --------------------------------------
# Install required directories
# --------------------------------------
install -d "${TARGET}"
install -d "${TARGET}/config.d/"

# --------------------------------------
# Link required files
# --------------------------------------
install -m 644 "${SOURCE}/dot-bash_profile"           "${HOME}/.bash_profile"
install -m 644 "${SOURCE}/dot-bash_logout"            "${HOME}/.bash_logout"
install -m 644 "${SOURCE}/dot-bashrc"                 "${HOME}/.bashrc"
install -m 644 "${SOURCE}/dot-config/bash/config.d"/* "${TARGET}/config.d"


TARGET="${HOME}/.local/bin"

install -d "${TARGET}"
