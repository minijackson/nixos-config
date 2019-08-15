#!/usr/bin/env nix-shell
#! nix-shell -i bash -p shntool cuetools flac

set -xeuo pipefail

cuesheet="$1"

audio="$2"
format="${audio##*.}"
albumdir=$(mktemp -d)

shnsplit -f "$cuesheet" "$audio" -d "${albumdir}" -o "${format}"
find "${albumdir}" -type f -print0  | sort -zn | xargs -t0 cuetag.sh "$cuesheet"
echo "Split exported to: '${albumdir}'"
