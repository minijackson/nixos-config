#!/bin/sh

# From: https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland

set -x

XDG_DATA_DIRS='@gsettings_desktop_schemas@/share/gsettings-schemas/@gsettings_desktop_schemas_name@':"$XDG_DATA_DIRS"
GIO_EXTRA_MODULES='@dconf_lib@/lib/gio/modules':$GIO_EXTRA_MODULES


# usage: import-gsettings <gsettings key>:<settings.ini key> <gsettings key>:<settings.ini key> ...

expression=""
for pair in "$@"; do
    IFS=:; set -- $pair
    expressions="$expressions -e 's:^$2=(.*)$:@gsettings@/bin/gsettings set org.gnome.desktop.interface $1 \1:e'"
done
IFS=
eval exec sed -E $expressions "${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini >/dev/null
