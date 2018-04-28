#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-scripts

set -euo pipefail
IFS=$'\n\t'

echo "Cding into ${0%/*}"
cd "${0%/*}"

url="$1"

pluginName="${url#*github\.com/*/}"
pluginName="${pluginName%.git}"

echo "Adding the Vim plugin '$pluginName'"

releaseFile="./vim-plugins/$pluginName.json"

if [ -f "$releaseFile" ]; then
	echo "'$releaseFile' already exists, not overwriting."
	exit 1
fi

nix-prefetch-git "$url" --fetch-submodules --quiet > "$releaseFile"
