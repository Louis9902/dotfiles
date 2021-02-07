#!/bin/bash

__bash_prompt_git_addon() {

	if [[ ! $(command -v git) ]]; then
		return
	fi

	local STATUS
	STATUS="$(git status --porcelain=2 --branch 2>/dev/null)"

	if [[ -z "${STATUS}" ]]; then
		return
	fi

	local GIT_M_FILES GIT_D_FILES GIT_A_FILES GIT_R_FILES GIT_U_FILES
	# see https://git-scm.com/docs/git-status for more information
	# these are status information from the local git index
	GIT_M_FILES="$(grep -c "^[12] M" <<<"${STATUS}")"
	GIT_D_FILES="$(grep -c "^[12] D" <<<"${STATUS}")"
	GIT_A_FILES="$(grep -c "^[12] A" <<<"${STATUS}")"
	GIT_R_FILES="$(grep -c "^[12] R" <<<"${STATUS}")"
	GIT_U_FILES="$(grep -c "^?" <<<"${STATUS}")"

	local GIT_BRANCH GIT_COMMIT
	GIT_BRANCH="$(awk '/branch.head/ {print $3}' <<<"${STATUS}")"
	GIT_COMMIT="$(awk '/branch.oid/ {print substr($3,0,8)}' <<<"${STATUS}")"

	local GIT_COMMITS_AH GIT_COMMITS_BH
	GIT_COMMITS_AH="$(awk '/branch.ab/ {print substr($3,2)}' <<<"${STATUS}")"
	GIT_COMMITS_BH="$(awk '/branch.ab/ {print substr($4,2)}' <<<"${STATUS}")"

	# check for branch name, if detached use branch head commit
	if [[ -n "${GIT_BRANCH}" ]]; then
		if [[ "${GIT_BRANCH}" != "(detached)" ]]; then
			GIT_BRANCH="(${GIT_BRANCH})"
		else
			GIT_BRANCH="{${GIT_COMMIT}}"
		fi
	else
		GIT_BRANCH="ERROR"
	fi

	# if git has changes show name in RED otherwise in GREEN
	local GIT_BRANCH_CHANGE
	if [[ "${GIT_M_FILES}" -eq '0' ]]; then
		GIT_BRANCH_CHANGE="$(font-fg 002)" # GREEN
	else
		GIT_BRANCH_CHANGE="$(font-fg 001)" # RED
	fi

	local PROMPT

	# add branch information to prompt
	PROMPT="${GIT_BRANCH_CHANGE}${GIT_BRANCH}$(font)"

	# add information if branch is behind of remote
	if [[ -n "${GIT_COMMITS_BH}" ]] && [[ "${GIT_COMMITS_BH}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 001)>$(font)${GIT_COMMITS_BH}" # RED
	fi

	# add information if branch is ahead of remote
	if [[ -n "${GIT_COMMITS_AH}" ]] && [[ "${GIT_COMMITS_AH}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 002)<$(font)${GIT_COMMITS_AH}" # GREEN
	fi

	# information about the status of the working tree

	if [[ "${GIT_M_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 005)~$(font)${GIT_M_FILES}" # PRUPLE
	fi

	if [[ "${GIT_D_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 001)-$(font)${GIT_D_FILES}" # RED
	fi

	if [[ "${GIT_A_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 002)+$(font)${GIT_A_FILES}" # GREEN
	fi

	if [[ "${GIT_R_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 004)*$(font)${GIT_R_FILES}" # BLUE
	fi

	if [[ "${GIT_U_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 003)?$(font)${GIT_U_FILES}" # YELLOW
	fi

	echo "${PROMPT}"
}

__bash_prompt_virtualenv_addon() {
	local PROMPT

	if [ -n "${VIRTUAL_ENV}" ]; then
		PROMPT="$(font-fg 027)[$(basename "${VIRTUAL_ENV}")]$(font)"
	fi

	echo "${PROMPT}"
}

__bash_info() {
	for i in {1..256}; do
		echo -e -n "\033[38;5;${i}m ⬛⬛ $(printf "%05d" "$i")"
		if [[ 0 == $((i % 10)) ]]; then
			echo
		fi
	done
	echo
}

__bash_prompt_set() {

	font() {
		local esc='\033'
		local format="\[${esc}[0m\]"
		case $# in
		2)
			format="\[${esc}[${1};5;${2}m\]"
			;;
		esac

		echo "${format}"
	}
	font-fg() { font 38 "$1"; }
	font-bg() { font 48 "$1"; }

	local CWD='\W'
	local USER='\u'
	local HOST='\h'
	local BANG='\$'

	local RESET_COLOR
	RESET_COLOR="$(font)"

	# basename of the current working directory
	local WORK_DIR_COLOR
	WORK_DIR_COLOR="$(font-fg 046)"
	CWD="${WORK_DIR_COLOR}${CWD}${RESET_COLOR}"

	# username of the current user
	local ROOT_UID_COLOR USER_UID_COLOR
	ROOT_UID_COLOR="$(font-fg 196)"
	USER_UID_COLOR="$(font-fg 202)"

	if [[ "${EUID}" == 0 ]]; then
		USER="${ROOT_UID_COLOR}${USER}${RESET_COLOR}"
	else
		USER="${USER_UID_COLOR}${USER}${RESET_COLOR}"
	fi

	# hostname up to the first
	local SSH_HOST_COLOR STD_HOST_COLOR
	SSH_HOST_COLOR="$(font-fg 196)"
	STD_HOST_COLOR="$(font-fg 011)"
	if [[ -n "${SSH_TTY}" ]]; then
		HOST="${SSH_HOST_COLOR}${HOST}${RESET_COLOR}"
	else
		HOST="${STD_HOST_COLOR}${HOST}${RESET_COLOR}"
	fi

	local -a BASH_PROMPT_EXTRA BASH_PROMPT_ADDON=(
		'__bash_prompt_virtualenv_addon'
		'__bash_prompt_git_addon'
	)

	# collect prompt addons
	local NAME VALUE
	for NAME in "${BASH_PROMPT_ADDON[@]}"; do
		VALUE="$($NAME)"
		if [[ -n "${VALUE}" ]]; then
			BASH_PROMPT_EXTRA+=(" ${VALUE}")
		fi
	done

	# concat prompt addons
	local EXTRA
	if [[ "${#BASH_PROMPT_EXTRA[@]}" -gt 0 ]]; then
		EXTRA+="${BASH_PROMPT_EXTRA[*]}"
		EXTRA+=' '
	fi

	PS1=''
	PS1+="[${USER}@${HOST} ${CWD}]${EXTRA}${BANG} "

	# Support for Virtual Terminal Emulator (GTK 3+ widget)
	if [[ $(command -v __vte_osc7) ]]; then
		PS1+="$(__vte_osc7)"
	fi

	# cleanup
	unset -f font font-fg font-bg
}

# tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=__bash_prompt_set
