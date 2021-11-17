#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/git"

require_system_executable '/usr/bin/git'

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
printf "Installing host spesific configuration for git\n"
install -m 644 "${SOURCE}/dot-config/git/config.d/host" "${LOCAL_CONFIG}"

GIT_USER="$(read_input_args 'git user' "$(get_default_user_name)")"
sed --in-place "s/\${GIT_USER}/${GIT_USER}/g" "${LOCAL_CONFIG}"
GIT_MAIL="$(read_input_args 'git mail' "$(get_default_user_mail)")"
sed --in-place "s/\${GIT_MAIL}/${GIT_MAIL}/g" "${LOCAL_CONFIG}"
fi

# --------------------------------------
# Link required files
# --------------------------------------
install -m 644 "${SOURCE}/dot-config/git/config"     "${TARGET}"
install -m 644 "${SOURCE}/dot-config/git/ignore"     "${TARGET}"
install -m 644 "${SOURCE}/dot-config/git/message"    "${TARGET}"
install -m 644 "${SOURCE}/dot-config/git/config.d"/* "${TARGET}/config.d"
rm "${TARGET}/config.d/host" # host template
