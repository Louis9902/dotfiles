SYSTEMD_RELOAD	:= systemctl --user daemon-reload
SYSTEMD_ENABLE	:= systemctl --user --now enable

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: ssh
ssh: ## initialize ssh
	mkdir -p ${HOME}/.ssh
	ln -vfs ${PWD}/ssh/dot-ssh/config ${HOME}/.ssh/config
	mkdir -p ${HOME}/.ssh/config.d
	touch ${HOME}/.ssh/config.d/$(hostname)
	chmod 644 ${HOME}/.ssh/config.d/*

.PHONY: gpg
gpg: ## initialize gpg
	mkdir -p ${HOME}/.gnupg
	ln -vfs ${PWD}/gpg/dot-gnupg/gpg-agent.conf ${HOME}/.gnupg/gpg-agent.conf
	ln -vfs ${PWD}/gpg/dot-gnupg/gpg.conf       ${HOME}/.gnupg/gpg.conf
	cp ${PWD}/gpg/dot-gnupg/sshcontrol          ${HOME}/.gnupg/sshcontrol
	mkdir -p ${HOME}/.config/systemd/user
	ln -vfs ${PWD}/gpg/dot-config/systemd/user/* ${HOME}/.config/systemd/user
	$(SYSTEMD_RELOAD)
	$(SYSTEMD_ENABLE) gpg-agent-ssh.socket

.PHONY: git
git: ## initialize git
	mkdir -p ${HOME}/.config/git
	ln -vfs ${PWD}/git/dot-config/git/* ${HOME}/.config/git

.PHONY: bash
bash:
	@ln -vfs ${PWD}/bash/dot-bashrc  ${HOME}/.bashrc
	@mkdir -p ${HOME}/.config/bash/.bashrc.d
	@ln -vfs ${PWD}/bash/dot-config/dot-bashrc.d/* ${HOME}/.config/bash/.bashrc.d
