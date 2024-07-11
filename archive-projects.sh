#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

source env-vars.sh

echo
echo "Archiving Obsolete Projects"
echo "= = ="
echo

source ./projects/archived-projects.sh

working_copies=(
  "${archived_projects[@]}"
)

cd "$projects_home"

if [ ! -d ".archive" ]; then
  echo "Creating archive directory for obsolete libraries"
  mkdir_cmd="mkdir .archive"
  contributor-assets/run-cmd.sh "$mkdir_cmd"
  echo
fi

for name in "${working_copies[@]}"; do
  echo "Archiving $name"

  if [ ! -d "$name" ]; then
    echo "$name not found in $projects_home. Skipping."
  else
    if [ -d ".archive/$name" ]; then
      echo ".archive/$name already exists. Already archived."
      rm_cmd="rm -rf $name"
      contributor-assets/run-cmd.sh "$rm_cmd"
    else
      mv_cmd="mv $name/ .archive/$name/"
      contributor-assets/run-cmd.sh "$mv_cmd"
    fi
  fi

  echo
done

echo "Done ($(basename "$0"))"
