#!/usr/bin/env bash
# Licensed under the BSD-3 Clause license. See LICENSE.

# Interactively lets you apply patches from an ebuild.

EBUILD=$1
REPO_PATH=$2
[[ -v 2 ]] || REPO_PATH=$(pwd)
# lie to ebuild.sh
shift 2

ver_test() { :; }
ver_cut() { :; }
ver_rs() { :; }
# is this morally correct
PORTAGE_BIN_PATH=$(printf /usr/lib/portage/python*/)
PORTAGE_PYM_PATH=$(printf /usr/lib/portage/python*/)
PORTAGE_ECLASS_LOCATIONS=( "/var/db/repos/gentoo" )
_IN_INSTALL_QA_CHECK=0
source /usr/lib/portage/*/ebuild.sh

die() { echo "$1" 1>&2; exit 1; }


echo " --- Using $EBUILD..."
source "$EBUILD"  2>/dev/null

[[ -v DESCRIPTION ]] || die "No description!"
[[ -v PATCHES ]] || die "No patches to apply!"

[[ "$REPO_PATH" = "$(pwd)" ]] || echo " --- Applying to specified directory: $REPO_PATH";

my_filesdir=$(dirname "$EBUILD")/files
for patch in "${PATCHES[@]}"; do
	patch="$my_filesdir$patch"
	read -N 1 -p "Apply \"$patch\"? " apply
	case $apply in
		[Yy]*) echo; patch < "$patch";;
		[Nn]*) echo ;;
		*) echo "Unknown option";;
	esac
done
