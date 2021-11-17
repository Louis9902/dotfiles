#!/usr/bin/env bash
# shellcheck disable=SC1090

for src in "${DOT_FILES_DIR}/scripts"/*.sh; do
	source "${src}" || exit 1
done

SOURCE="$(dirname "$(realpath "$0")")"
TARGET="${HOME}/.gnupg"

require_system_executable '/usr/bin/gpg2'
require_system_executable '/usr/bin/pinentry-gnome3'

# --------------------------------------
# Install required directories
# --------------------------------------
install -d "${TARGET}"


# --------------------------------------
# Link required files
# --------------------------------------
install -m 644 "${SOURCE}/dot-gnupg"/* "${TARGET}"


# --------------------------------------
# Install systemd service units for user
# --------------------------------------
SYSTEMD_USER_UNITS="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
install -d "${SYSTEMD_USER_UNITS}"

install "${SOURCE}/dot-config/systemd/user/gpg-agent.service"        "${SYSTEMD_USER_UNITS}"
install "${SOURCE}/dot-config/systemd/user/gpg-agent.socket"         "${SYSTEMD_USER_UNITS}"
install "${SOURCE}/dot-config/systemd/user/gpg-agent-ssh.socket"     "${SYSTEMD_USER_UNITS}"
install "${SOURCE}/dot-config/systemd/user/gpg-agent-extra.socket"   "${SYSTEMD_USER_UNITS}"
install "${SOURCE}/dot-config/systemd/user/gpg-agent-browser.socket" "${SYSTEMD_USER_UNITS}"

systemctl --user daemon-reload
systemctl --user enable --now 'gpg-agent-ssh.socket'
