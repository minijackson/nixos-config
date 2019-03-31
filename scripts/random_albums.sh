#!/bin/sh

set -euo pipefail
IFS=$'\n\t'

separator="―"

results="$(@beets@/bin/beet random --time 300 --equal-chance --album --format '$albumartist '$separator' $album')"

for result in $results; do
	IFS="$separator" read -ra artistalbum <<< "$result"

	 # Strip the whitespace
	 artist="${artistalbum[0]% }"
	 album="${artistalbum[1]# }"

	 @mpc_cli@/bin/mpc findadd albumartist "$artist" album "$album"
done
