#!/bin/sh

set -euo pipefail
IFS=$'\n\t'

artist="$(@mpc_cli@/bin/mpc list albumartist | @rofi@/bin/rofi -dmenu -fullscreen -columns 2 -i)"

@mpc_cli@/bin/mpc findadd albumartist "$artist"
