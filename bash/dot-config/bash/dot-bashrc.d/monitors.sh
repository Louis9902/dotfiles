#!/usr/bin/env bash

monitors()
{
	case "$1" in
		off)
			busctl --user \
			call org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig \
			org.gnome.Mutter.DisplayConfig ApplyMonitorsConfig "uua(iiduba(ssa{sv}))a{sv}" \
			2 1 1 0 0 1.0 0 true 1 'HDMI-2' '2560x1080@59.999534606933594' 0 \
			    0
		;;
		on)
			busctl --user \
			call org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig \
			org.gnome.Mutter.DisplayConfig ApplyMonitorsConfig "uua(iiduba(ssa{sv}))a{sv}" \
			2 1 2 0    0 1.0 0 false 1 'HDMI-1' '2560x1080@59.999534606933594' 0 \
			      2560 0 1.0 0 true  1 'HDMI-2' '2560x1080@59.999534606933594' 0 \
			    0
		;;
		*)
		echo "monitors (off|on)"
		;;
	esac
}

screens $@