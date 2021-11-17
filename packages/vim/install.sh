#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

require_system_executable '/usr/bin/nvim'

# --------------------------------------
# Install required directories
# --------------------------------------
install -d "${TARGET}"
install -d "${TARGET}/config.d/"

# --------------------------------------
# Create local configuration file
# --------------------------------------
LOCAL_CONFIG="${TARGET}/config.d/$(hostname).vim"
if [[ ! -e "${LOCAL_CONFIG}" ]]; then
printf "Installing host spesific configuration for nvim\n"
install -m 644 "${SOURCE}/dot-config/nvim/config.d/host" "${LOCAL_CONFIG}"
fi

# --------------------------------------
# Link required files
# --------------------------------------
install -m 644 "${SOURCE}/dot-config/nvim/init.vim"   "${TARGET}"
install -m 644 "${SOURCE}/dot-config/nvim/config.d"/* "${TARGET}/config.d"
rm "${TARGET}/config.d/host" # host template