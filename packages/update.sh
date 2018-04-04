#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-prefetch-scripts

set -euo pipefail
IFS=$'\n\t'

function update_from_github() {
	local releaseFile="$1"
	local url="$2"

	userrepo="${url##*github\.com/}"

	user="${userrepo%%/*}"
	repo="${userrepo#$user/}"
	repo="${repo%.git}"

	if tag="$(jq -er .tag "$releaseFile")"; then
		update_from_tag "$releaseFile" "$url" "$user" "$repo" "$tag"
	#elif branch="$(jq -er .tag "$releaseFile")"; then
	#	update_from_branch "$releaseFile" "$url" "$branch"
	else
		update_from_branch "$releaseFile" "$url"
	fi
}

function update_from_branch() {
	local releaseFile="$1"
	local url="$2"

	echo "Updating from branch"

	nix-prefetch-git "$url" --fetch-submodules --quiet > "$releaseFile"
}

function update_from_tag() {
	local releaseFile="$1"
	local url="$2"
	local user="$3"
	local repo="$4"
	local currentTag="$5"

	set +e
	latestRelease="$(curl -sSf "https://api.github.com/repos/$user/$repo/releases/latest" 2>&1)"
	releaseResult=$?
	set -e

	if [[ "$releaseResult" != 0 ]]; then
		if [[ "$latestRelease" = "*404 Not Found" ]]; then
			echo "Project not using the GitHub release system, skipping…"
			return
		else
			echo "Failed to download the latest release"
			exit 1
		fi
	fi

	latestTag="$(echo "$latestRelease" | jq -er .tag_name)"

	if [[ "$currentTag" == "$latestTag" ]]; then
		echo "Unchanged, skipping..."
		return
	fi

	#latestRevision="$(curl -sSf "https://api.github.com/repos/$user/$repo/git/refs/tags/$latestTag" | jq -r .object.sha)"

	echo "Updating $package from '$currentTag' to '$latestTag'"

	nix-prefetch-git "$url" "$latestTag" --fetch-submodules --quiet | jq ". + {\"tag\": \"$latestTag\"}" > "$releaseFile"
}

for releaseFile in **/release-info.json; do
	package="${releaseFile%/release-info.json}"
	package="${package##*/}"

	echo "Processing $package"

	url="$(jq -er .url "$releaseFile")"

	if [[ ! "$url" =~ ^(https?|git)://github\.com/ ]]; then
		echo "Not a GitHub hosted project, skipping..."
		continue
	fi

	update_from_github "$releaseFile" "$url"
done

echo "All done!"
