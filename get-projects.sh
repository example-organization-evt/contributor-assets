#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

export GIT_CONFIG=/dev/null

source settings.sh

echo
echo "Get Projects"
echo "= = ="
echo

echo "Projects Home: $PROJECTS_HOME"
echo "Remote Authority Path: $GIT_AUTHORITY_PATH"
echo "Remote Name: $GIT_REMOTE_NAME"
echo "Default Branch: $GIT_DEFAULT_BRANCH"

autostash=${AUTOSTASH:-off}
parallel=${GET_PROJECTS_PARALLEL:-off}

echo
echo "Parallel: $parallel"
echo "Autostash: $autostash"

source ./projects/projects.sh

./archive-projects.sh

export run_cmd_path="$(realpath ./run-cmd.sh)"
function run-cmd() {
  cmd=$1

  $run_cmd_path "$1"
}
export -f run-cmd

function clone-repo() {
  local name=$1

  remote_repository_url="$GIT_AUTHORITY_PATH/$name.git"

  echo "Cloning: $remote_repository_url"

  clone_cmd="git clone $remote_repository_url"
  run-cmd "$clone_cmd"
}
export -f clone-repo

function pull-repo() {
  local name=$1

  echo "Pulling: $name ($GIT_DEFAULT_BRANCH branch only)"

  dir="$PROJECTS_HOME/$name"
  cd "$dir"

  if [ "$autostash" = "on" ]; then
    autostash_flag="--autostash"
  else
    if ! git diff --quiet; then
      echo
      echo "Working tree is dirty, aborting ($name)"
      echo
      exit 1
    fi

    autostash_flag="--no-autostash"
  fi

  current_branch=$(git branch --no-color 2> /dev/null | sed -n -e 's/* \(.*\)/\1/p')
  if [ master != "$current_branch" ]; then
    checkout_cmd="git checkout $GIT_DEFAULT_BRANCH"
    run-cmd "$checkout_cmd"
  fi

  pull_cmd="git pull $autostash_flag --rebase=merges $GIT_REMOTE_NAME $GIT_DEFAULT_BRANCH"
  run-cmd "$pull_cmd"

  if [ "$current_branch" != "$GIT_DEFAULT_BRANCH" ]; then
    co_current_cmd="git checkout $current_branch --quiet"
    run-cmd "$co_current_cmd"
  fi
}
export -f pull-repo

function update-repo() {
  name=$1

  echo
  echo "$name"
  echo "- - -"

  cd "$PROJECTS_HOME"

  dir=$name

  if [ ! -d "$dir/.git" ]; then
    clone-repo "$name"
  else
    pull-repo "$name"
  fi
}
export -f update-repo

working_copies=(
  "${projects[@]}"
)

echo
echo "Getting code from $GIT_AUTHORITY_PATH ($GIT_REMOTE_NAME)"

if [ "$parallel" = "on" ] && command -v parallel >/dev/null; then
  jobs=${GET_PROJECTS_PARALLEL_JOBS:-16}

  function update {
    slot="$2"

    if [ -z "${GIT_SSH_COMMAND:-}" ]; then
      control_path="$TMPDIR/%r@%h:%p-$slot"
      export GIT_SSH_COMMAND="ssh -o ControlMaster=auto -o ControlPersist=1m -o ControlPath=$control_path -o Compression=yes"
    fi

    update-repo "$1"
  }
  export -f update

  parallel --jobs "$jobs" --halt now,fail=1 update "{}" "{%}" ::: "${working_copies[@]}"
else
  for name in "${working_copies[@]}"; do
    update-repo "$name"
  done
fi

echo
echo "Done ($(basename "$0"))"
