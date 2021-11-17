#!/usr/bin/env bash

# common functions for working with file permissions

# ---------------------------------------------
# ---------------------------------------------
alias perm='stat --printf "%a %n \n "'	# perm: show permission of target in number

# ---------------------------------------------
# ---------------------------------------------
alias 000='chmod 000'	# ---------- (user: -, group: -, other: -)
alias 640='chmod 640'	# -rw-r----- (user: rw, group: r, other: -)
alias 644='chmod 644'	# -rw-r--r-- (user: rw, group: r, other: -)
alias 755='chmod 755'	# -rwxr-xr-x (user: rwx, group: rx, other: x)
alias 775='chmod 775'	# -rwxrwxr-x (user: rwx, group: rwx, other: rx)

# ---------------------------------------------
# ---------------------------------------------
alias ux='chmod u+x'	# ---x------ (user: --x, group: -, other: -)
alias mx='chmod a+x'	# ---x--x--x (user: --x, group: --x, other: --x)
