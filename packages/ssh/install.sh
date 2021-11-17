#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${HOME}/.ssh"

require_system_executable '/usr/bin/ssh'

# --------------------------------------
# Install required directories
# --------------------------------------
install -d "${TARGET}"
install -d "${TARGET}/config.d/"

# --------------------------------------
# Create local configuration file
# --------------------------------------
LOCAL_CONFIG="${TARGET}/config.d/$(hostname)"
if [[ ! -e "${LOCAL_CONFIG}" ]]; then
printf "Installing host spesific configuration for ssh\n"
install -m 644 "${SOURCE}/dot-ssh/config.d/host" "${LOCAL_CONFIG}"
fi

# --------------------------------------
# Link required files
# --------------------------------------
install -m 644 "${SOURCE}/dot-ssh/config"     "${TARGET}"
install -m 644 "${SOURCE}/dot-ssh/config.d"/* "${TARGET}/config.d"
rm "${TARGET}/config.d/host" # host template