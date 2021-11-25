#!/usr/bin/env bash

gh_get_latest_release() {
	curl -L --silent -H "Accept: application/vnd.github.v3.raw+json" \
		"https://api.github.com/repos/$1/releases/latest" | jq -c
}

gh_get_latest_release_url() {
	gh_get_latest_release "$1" | { read -r json;
		jq -r '.tag_name' <<<"${json}"
		jq -r '.assets[] | select(.name | endswith(".el7.x86_64.rpm")).browser_download_url' <<<"${json}"
	}
}