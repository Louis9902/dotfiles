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

	# check for branch NAME, if detached use branch head commit
	if [[ -n "${GIT_BRANCH}" ]]; then
		if [[ "${GIT_BRANCH}" != "(detached)" ]]; then
			GIT_BRANCH="(${GIT_BRANCH})"
		else
			GIT_BRANCH="{${GIT_COMMIT}}"
		fi
	else
		GIT_BRANCH="ERROR"
	fi

	# if git has changes show NAME in RED otherwise in GREEN
	local GIT_BRANCH_CHANGE
	if [[ "${GIT_M_FILES}" -eq '0' ]]; then
		GIT_BRANCH_CHANGE="$(font-fg 046)" # GREEN
	else
		GIT_BRANCH_CHANGE="$(font-fg 196)" # RED
	fi

	local PROMPT

	# add branch information to prompt
	PROMPT="${GIT_BRANCH_CHANGE}${GIT_BRANCH}$(font)"

	# add information if branch is behind of remote
	if [[ -n "${GIT_COMMITS_BH}" ]] && [[ "${GIT_COMMITS_BH}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 196)>$(font)${GIT_COMMITS_BH}" # RED
	fi

	# add information if branch is ahead of remote
	if [[ -n "${GIT_COMMITS_AH}" ]] && [[ "${GIT_COMMITS_AH}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 046)<$(font)${GIT_COMMITS_AH}" # GREEN
	fi

	# information about the status of the working tree

	if [[ "${GIT_M_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 201)~$(font)${GIT_M_FILES}" # PRUPLE
	fi

	if [[ "${GIT_D_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 196)-$(font)${GIT_D_FILES}" # RED
	fi

	if [[ "${GIT_A_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 046)+$(font)${GIT_A_FILES}" # GREEN
	fi

	if [[ "${GIT_R_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 027)*$(font)${GIT_R_FILES}" # BLUE
	fi

	if [[ "${GIT_U_FILES}" -gt 0 ]]; then
		PROMPT+=" $(font-fg 011)?$(font)${GIT_U_FILES}" # YELLOW
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

	# basename of the current working directory
	local WORK_DIR
	WORK_DIR="$(font-fg 046)"
	CWD="${WORK_DIR}${CWD}$(font)"

	# username of the current user
	local ROOT_UID USER_UID
	ROOT_UID="$(font-fg 196)"
	USER_UID="$(font-fg 202)"
	if [[ "${EUID}" == 0 ]]; then
		USER="${ROOT_UID}${USER}$(font)"
	else
		USER="${USER_UID}${USER}$(font)"
	fi

	# hostname up to the first
	local SSH_HOST STD_HOST
	SSH_HOST="$(font-fg 196)"
	STD_HOST="$(font-fg 011)"
	if [[ -n "${SSH_TTY}" ]]; then
		HOST="${SSH_HOST}${HOST}$(font)"
	else
		HOST="${STD_HOST}${HOST}$(font)"
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
	PS1+="[${USER}@${HOST} ${CWD}]${EXTRA}"
	PS1+="${BANG} "

	# cleanup
	unset -f font font-fg font-bg
}

# tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=__bash_prompt_set
