#!/usr/bin/env bash

monitors()
{
	serial=$(busctl --user \
	call org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig \
	org.gnome.Mutter.DisplayConfig GetCurrentState \
	--json short | jq ".data[0]")
	case "$1" in
		off)
			busctl --user \
			call org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig \
			org.gnome.Mutter.DisplayConfig ApplyMonitorsConfig "uua(iiduba(ssa{sv}))a{sv}" \
			$serial 1 1 0 0 1.0 0 true 1 'HDMI-2' '2560x1080@59.999534606933594' 0 \
			    0
		;;
		on)
			busctl --user \
			call org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig \
			org.gnome.Mutter.DisplayConfig ApplyMonitorsConfig "uua(iiduba(ssa{sv}))a{sv}" \
			$serial 1 2 0    0 1.0 0 false 1 'HDMI-1' '2560x1080@59.999534606933594' 0 \
			      2560 0 1.0 0 true  1 'HDMI-2' '2560x1080@59.999534606933594' 0 \
			    0
		;;
		*)
		echo "monitors (off|on)"
		;;
	esac
}

update-codium() {
	local just_rpm='map(select(.content_type=="application/x-rpm"))'
	local just_amd='map(select(.name | endswith(".el7.x86_64.rpm")))'
	local json="$(curl -S -s -H "Accept: application/vnd.github.v3+json" \
				'https://api.github.com/repos/vscodium/vscodium/releases?per_page=1')"
	echo "Updating to version: $(jq '.[0].tag_name' <<<"${json}")"
	local url="$(jq -r ".[0] | (.assets | $just_rpm | $just_amd | .[0].browser_download_url)" <<<"${json}")"
	sudo dnf install "${url}"
}

