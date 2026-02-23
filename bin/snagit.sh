#!/usr/bin/env bash
# Licensed under the BSD-3 Clause license. See LICENSE.

# Script for copying ebuilds over from some git 

stuff=()

opt_repo=$(pwd)
opt_files=0
opt_stfu=0

while getopts "r:si" opt; do case $opt in
	r)  opt_repo=$OPTARG; ;;
	i) opt_files=1 ;;
	s)  opt_stfu=1 ;;
	\?) echo "YOU DUMBASS!"; exit 1 ;;
esac done
shift $((OPTIND-1))

opt_range=$1

function prompt_stuff()
{
	echo "These 'things' will get snagged and dropped into $(pwd)."
	echo
	for thing in "${stuff[@]}"; do
		echo -e "  \x1b[1m$thing\x1b[0m"
	done
	
	if [[ $opt_stfu -eq 0 ]]; then
		echo
		printf "Do you consent? (y/n) "
		read -n 1 ans
		echo
		[[ $ans == "y" ]]
		return $?
	fi
	echo
	return 0
}

for file in $(git --git-dir="${opt_repo}/.git/" log "${opt_range}" --name-only --format=); do
	if [[ $opt_files -eq 1 ]]; then
		echo ":/"
	else
		justdir=$(dirname "${file}")
		# ignore duplicates
		exists=0
		for dir in "${stuff[@]}"; do
			[[ "$dir" == "$justdir" ]] && exists=1 && break
		done
		[[ exists -eq 0 ]] && stuff+=( "${justdir}" )
	fi
done

prompt_stuff || exit 1

for file in "${stuff[@]}"; do
	if [[ $opt_files -eq 0 ]]; then
		echo mkdir -p "./$file"
		echo "${opt_repo}$file" -\> "./$file"
		echo cp -r "${opt_repo}$file" $(dirname "./$file")
	fi
done
