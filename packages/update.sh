#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-prefetch-scripts

set -euo pipefail
IFS=$'\n\t'

function update_from_github() {
	local releaseFile="$1"
	local url="$2"

	local userrepo="${url##*github\.com/}"

	local user="${userrepo%%/*}"
	local repo="${userrepo#$user/}"
	repo="${repo%.git}"

	local tag
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

	local newContent
	newContent="$(nix-prefetch-git "$url" --fetch-submodules --quiet)" 

	overwrite-release-file "$newContent" "$releaseFile"
}

function update_from_tag() {
	local releaseFile="$1"
	local url="$2"
	local user="$3"
	local repo="$4"
	local currentTag="$5"

	local latestRelease
	set +e
	latestRelease="$(curl -sSf "https://api.github.com/repos/$user/$repo/releases/latest" 2>&1)"
	local releaseResult=$?
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

	local latestTag
	latestTag="$(echo "$latestRelease" | jq -er .tag_name)"

	if [[ "$currentTag" == "$latestTag" ]]; then
		echo "Unchanged, skipping..."
		return
	fi

	#latestRevision="$(curl -sSf "https://api.github.com/repos/$user/$repo/git/refs/tags/$latestTag" | jq -r .object.sha)"

	echo "Updating $package from '$currentTag' to '$latestTag'"

	local newContent
	newContent="$(nix-prefetch-git "$url" "$latestTag" --fetch-submodules --quiet | jq ". + {\"tag\": \"$latestTag\"}")"

	overwrite-release-file "$newContent" "$releaseFile"
}

function overwrite-release-file() {
	local newContent="$1"
	local releaseFile="$2"

	local oldRev newRev
	oldRev="$(jq -er .rev < "$releaseFile")"
	newRev="$(echo "$newContent" | jq -er .rev)"

	if [[ "$oldRev" == "$newRev" ]]; then
		echo "Commit didn't change, doing nothing"
		return
	fi

	local url
	url="$(jq -er .url < "$releaseFile")"

	if [[ "$url" =~ ^(https?|git)://github\.com/ ]]; then
		local userrepo="${url##*github\.com/}"

		local user="${userrepo%%/*}"
		local repo="${userrepo#$user/}"
		local repo="${repo%.git}"

		echo "View changes: https://github.com/$user/$repo/compare/$oldRev..$newRev"
	fi

	echo "$newContent" > "$releaseFile"
}

for releaseFile in ./vim-plugins/*.json **/release-info.json ; do
	if [[ "$releaseFile" =~ ^./vim-plugins/ ]]; then
		package="${releaseFile#./vim-plugins/}"
		package="Vim plugin ${package%.json}"
	else
		package="${releaseFile%/*.json}"
		package="${package##*/}"
	fi

	echo "* Processing $package"

	url="$(jq -er .url "$releaseFile")"

	if [[ ! "$url" =~ ^(https?|git)://github\.com/ ]]; then
		echo "Not a GitHub hosted project, skipping..."
		continue
	fi

	update_from_github "$releaseFile" "$url"

	echo
done

echo "All done!"
