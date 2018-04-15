#!/bin/sh

set -euo pipefail
IFS=$'\n\t'

separator="―"

library_file="${XDG_CONFIG_HOME:-$HOME/.config}/beets/library.db"

#result="$(@mpc_cli@/bin/mpc --format="%albumartist% $separator %album%" listall | @coreutils@/bin/uniq | @rofi@/bin/rofi -dmenu -fullscreen -columns 2 -i)"
result="$(@sqlite@/bin/sqlite3 "$library_file" "SELECT albumartist || ' $separator ' || album FROM albums ORDER BY added DESC;" | @rofi@/bin/rofi -dmenu -fullscreen -columns 2 -i)"

IFS="$separator" read -ra artistalbum <<< "$result"

# Strip the whitespace
artist="${artistalbum[0]% }"
album="${artistalbum[1]# }"

@mpc_cli@/bin/mpc findadd albumartist "$artist" album "$album"
