#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/gdb"

# --------------------------------------
# Install required directories
# --------------------------------------
install -d "${TARGET}"
install -d "${TARGET}/config.d/"