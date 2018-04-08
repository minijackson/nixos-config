#!/bin/sh

set -euo pipefail
IFS=$'\n\t'

separator="―"

result="$(@mpc_cli@/bin/mpc --format="%albumartist% $separator %album%" listall | @coreutils@/bin/uniq | @rofi@/bin/rofi -dmenu -fullscreen -columns 2 -i)"

IFS="$separator" read -ra artistalbum <<< "$result"

# Strip the whitespace
artist="${artistalbum[0]% }"
album="${artistalbum[1]# }"

@mpc_cli@/bin/mpc findadd albumartist "$artist" album "$album"
