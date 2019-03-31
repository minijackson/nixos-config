#!/bin/sh

# Very inspired by:
# https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu

set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | @rofi@/bin/rofi -dmenu -i)

@pass@/bin/pass show -c "$password" 2> /dev/null
