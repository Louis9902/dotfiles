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
	
	# branch
	# git status --porcelain=2 --branch | grep '# branch.head' | cut -c 15-
	# commit 
	# git status --porcelain=2 --branch | grep '# branch.oid' | cut -c 14- | cut -c 1-8
	# ahead
	# git status --porcelain=2 --branch | grep '# branch.ab' | cut -c 13- | cut -d ' ' -f 1
	# behind
	# git status --porcelain=2 --branch | grep '# branch.ab' | cut -c 13- | cut -d ' ' -f 2

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
		GIT_BRANCH_CHANGE="$(ansi setaf 002)" # GREEN
	else
		GIT_BRANCH_CHANGE="$(ansi setaf 001)" # RED
	fi

	local PROMPT

	# add branch information to prompt
	PROMPT="${GIT_BRANCH_CHANGE}${GIT_BRANCH}$(ansi sgr0)"

	# add information if branch is behind of remote
	if [[ -n "${GIT_COMMITS_BH}" ]] && [[ "${GIT_COMMITS_BH}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 001)>$(ansi sgr0)${GIT_COMMITS_BH}" # RED
	fi

	# add information if branch is ahead of remote
	if [[ -n "${GIT_COMMITS_AH}" ]] && [[ "${GIT_COMMITS_AH}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 002)<$(ansi sgr0)${GIT_COMMITS_AH}" # GREEN
	fi

	# information about the status of the working tree

	if [[ "${GIT_M_FILES}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 005)~$(ansi sgr0)${GIT_M_FILES}" # PRUPLE
	fi

	if [[ "${GIT_D_FILES}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 001)-$(ansi sgr0)${GIT_D_FILES}" # RED
	fi

	if [[ "${GIT_A_FILES}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 002)+$(ansi sgr0)${GIT_A_FILES}" # GREEN
	fi

	if [[ "${GIT_R_FILES}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 004)*$(ansi sgr0)${GIT_R_FILES}" # BLUE
	fi

	if [[ "${GIT_U_FILES}" -gt 0 ]]; then
		PROMPT+=" $(ansi setaf 003)?$(ansi sgr0)${GIT_U_FILES}" # YELLOW
	fi

	echo -n " ${PROMPT}"
}

__bash_prompt_virtualenv_addon() {
	local PROMPT

	if [ -n "${VIRTUAL_ENV}" ]; then
		PROMPT="$(ansi setaf 27)[$(basename "${VIRTUAL_ENV}")]$(ansi sgr0)"
		printf " %s" ${PROMPT}
	fi
}

# color lookup table
# for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done

__bash_prompt_set() {
	ansi() { printf "\[%s\]" "$(tput $@)"; }

	# set window title
	# see https://gist.github.com/justinmk/a5102f9a0c1810437885a04a07ef0a91
	local pwd='~'
	[ "$PWD" != "$HOME" ] && pwd=${PWD/#$HOME\//\~\/}
	pwd="${pwd//[[:cntrl:]]}"
	printf "\033]2;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${pwd}"


	local USER_PART
	# username of the current user
	if [[ "${EUID}" == 0 ]]; then
		USER_PART="$(tput setaf 160)\u$(tput sgr0)"
	else
		USER_PART="$(tput setaf 161)\u$(tput sgr0)"
	fi
	
	local HOST_PART
	# hostname of the system
	if [[ -n "${SSH_TTY}" ]]; then
		HOST_PART="$(tput setaf 158)$(tput smul)\h$(tput sgr0)"
	else
		HOST_PART="$(tput setaf 164)\h$(tput sgr0)"
	fi
	
	local PATH_PART
	# basename of the current path
	PATH_PART="$(tput setaf 111)\W$(tput sgr0)"
	
	local BANG_PART='\$'
	
	# concat prompt addons
	local INFORMATION=''

	INFORMATION+="$(__bash_prompt_virtualenv_addon)"
	INFORMATION+="$(__bash_prompt_git_addon)"

	if [[ -n "${INFORMATION}" ]]; then
		INFORMATION="${INFORMATION} "
	fi
	
	PS1="[${USER_PART}@${HOST_PART} ${PATH_PART}]${INFORMATION}${BANG_PART} "

	# cleanup
	unset -f ansi
}

contains() {
  local i match="$1"
  shift
  for i; do [[ "$i" == "$match" ]] && return 0; done
  return 1
}

# append the custom prompt function to the array of pre prompt commands
# NOTE: This is because VTE has also some hooks
if ! contains "__bash_prompt_set" "${PROMPT_COMMAND[@]}"; then
	PROMPT_COMMAND+=(__bash_prompt_set)
fi

unset -f contains
