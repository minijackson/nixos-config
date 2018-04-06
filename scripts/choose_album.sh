#!/bin/sh

set -euo pipefail
IFS=$'\n\t'

separator="―"

result="$(@mpc@ --format="%albumartist% $separator %album%" listall | @uniq@ | @rofi@ -dmenu -fullscreen -columns 2 -i)"

IFS="$separator" read -ra artistalbum <<< "$result"

# Strip the whitespace
artist="${artistalbum[0]% }"
album="${artistalbum[1]# }"

@mpc@ findadd albumartist "$artist" album "$album"
