#!/bin/bash
# Licensed under the BSD-3 Clause license. See LICENSE.

# Interactively lets you apply patches from an ebuild.

EBUILD=$1
REPO_PATH=$2
[[ -v 2 ]] || REPO_PATH=$(pwd)

# Yep.
inherit() { :; }
python_gen_cond_dep() { :; }
ver_cut() { :; }
python_gen_any_dep() { :; }

die() { echo "$1" 1>&2; exit 1; }

FILESDIR=$(dirname "$EBUILD")/files

echo " --- Using $EBUILD..."
source "$EBUILD"

[[ -v DESCRIPTION ]] || die "No description!"
[[ -v PATCHES ]] || die "No patches to apply!"

[[ "$REPO_PATH" = "$(pwd)" ]] || echo " --- Applying to specified directory: $REPO_PATH";

for patch in "${PATCHES[@]}"; do
	read -N 1 -p "Apply \"$patch\"? " apply
	case $apply in
		[Yy]*) echo; patch < "$patch";;
		[Nn]*) echo ;;
		*) echo "Unknown option";;
	esac
done
