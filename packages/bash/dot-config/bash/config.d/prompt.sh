#!/bin/bash
# shellcheck disable=SC2155

__bash_prompt_git_addon() {
	[[ $(command -v git) ]] || return

	local STATUS
	STATUS="$(LC_ALL=C git status --porcelain=2 --branch 2>/dev/null)"
	[[ -z "${STATUS}" ]] && return

	# see https://git-scm.com/docs/git-status for more information
	# these are status information from the local git index
	local GIT_M_FILES="$( grep -c "^[12] M" <<<"${STATUS}" )"
	local GIT_A_FILES="$( grep -c "^[12] A" <<<"${STATUS}" )"
	local GIT_D_FILES="$( grep -c "^[12] D" <<<"${STATUS}" )"
	local GIT_R_FILES="$( grep -c "^[12] R" <<<"${STATUS}" )"
	local GIT_C_FILES="$( grep -c "^[12] C" <<<"${STATUS}" )"
	local GIT_U_FILES="$( grep -c "^?" <<<"${STATUS}" )"

	local GIT_COMMIT GIT_BRANCH
	GIT_COMMIT="$( grep '# branch.oid'  <<<"${STATUS}" | cut -c 14- | cut -c 1-8 )"
	GIT_BRANCH="$( grep '# branch.head' <<<"${STATUS}" | cut -c 15- )"

	local GIT_COMMITS GIT_COMMITS_AH GIT_COMMITS_BH
	GIT_COMMITS="$( grep '# branch.ab' <<<"${STATUS}" | cut -c 13- )"
	GIT_COMMITS_AH="$( echo "${GIT_COMMITS}" | cut -d ' ' -f 1 )"
	GIT_COMMITS_BH="$( echo "${GIT_COMMITS}" | cut -d ' ' -f 2 )"

	# check for branch name, if detached use branch head commit
	if [[ -n "${GIT_BRANCH}" ]]; then
		if [[ "${GIT_BRANCH}" != "(detached)" ]]; then
			GIT_BRANCH="(${GIT_BRANCH})"
		else
			GIT_BRANCH="{${GIT_COMMIT}}"
		fi
	else
		GIT_BRANCH=''
	fi

	# if git has changes show name in RED otherwise in GREEN
	local GIT_BRANCH_CHANGE
	if [[ "${GIT_M_FILES}" -eq '0' ]]; then
		GIT_BRANCH_CHANGE="\[$(tput setaf 002)\]" # GREEN
	else
		GIT_BRANCH_CHANGE="\[$(tput setaf 001)\]" # RED
	fi

	local PROMPT

	# add branch information to prompt
	PROMPT="${GIT_BRANCH_CHANGE}${GIT_BRANCH}\[$(tput sgr0)\]"

	# add information if branch is behind of remote
	if [[ -n "${GIT_COMMITS_BH}" ]] && [[ "${GIT_COMMITS_BH}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 001)>$(tput sgr0)${GIT_COMMITS_BH}" # RED
	fi

	# add information if branch is ahead of remote
	if [[ -n "${GIT_COMMITS_AH}" ]] && [[ "${GIT_COMMITS_AH}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 002)<$(tput sgr0)${GIT_COMMITS_AH}" # GREEN
	fi

	# information about the status of the working tree

	if [[ "${GIT_M_FILES}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 005)\]~\[$(tput sgr0)\]${GIT_M_FILES}" # PRUPLE
	fi

	if [[ "${GIT_D_FILES}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 001)\]-\[$(tput sgr0)\]${GIT_D_FILES}" # RED
	fi

	if [[ "${GIT_A_FILES}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 002)\]+\[$(tput sgr0)\]${GIT_A_FILES}" # GREEN
	fi

	if [[ "${GIT_R_FILES}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 004)*\[$(tput sgr0)\]${GIT_R_FILES}" # BLUE
	fi

	if [[ "${GIT_U_FILES}" -gt 0 ]]; then
		PROMPT+=" \[$(tput setaf 003)\]?\[$(tput sgr0)\]${GIT_U_FILES}" # YELLOW
	fi

	echo -ne "${PROMPT}"
}

__bash_prompt_virtualenv_addon() {
	local PROMPT

	if [ -n "${VIRTUAL_ENV}" ]; then
		PROMPT="\[$(tput setaf 27)\][$(basename "${VIRTUAL_ENV}")]\[$(tput sgr0)\]"
		echo -ne "${PROMPT}"
	fi
}

__bash_prompt_set() {
	
	# set window title
	# see https://gist.github.com/justinmk/a5102f9a0c1810437885a04a07ef0a91
	local pwd='~'
	[ "$PWD" != "$HOME" ] && pwd=${PWD/#$HOME\//\~\/}
	pwd="${pwd//[[:cntrl:]]}"
	printf "\033]2;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${pwd}"


	local USER_
	# username of the current user
	if [[ "${EUID}" == 0 ]]; then
		USER_="\[$(tput setaf 160)\]\u\[$(tput sgr0)\]"
	else
		USER_="\[$(tput setaf 161)\]\u\[$(tput sgr0)\]"
	fi
	
	local HOST_
	# hostname of the system
	if [[ -n "${SSH_TTY}" ]]; then
		HOST_="\[$(tput setaf 158)\]\[$(tput smul)\]\h\[$(tput sgr0)\]"
	else
		HOST_="\[$(tput setaf 164)\]\h\[$(tput sgr0)\]"
	fi
	
	local PATH_
	# basename of the current path
	PATH_="\[$(tput setaf 111)\]\W\[$(tput sgr0)\]"
	
	local BANG_='\$'
	
	local INFORMATION=''
	add_prompt_part() {
		local result=" $($1)"
		INFORMATION+="${result%% }"
	}
	add_prompt_part '__bash_prompt_virtualenv_addon'
	add_prompt_part '__bash_prompt_git_addon'
	
	PS1="[${USER_}@${HOST_} ${PATH_}]${INFORMATION%% } ${BANG_} "
}

# Append the custom prompt function to the array of pre prompt commands
# NOTE: This is because VTE has also some hooks
if [[ ! " ${PROMPT_COMMAND[*]} " =~ " __bash_prompt_set " ]]; then
    PROMPT_COMMAND+=(__bash_prompt_set)
fi