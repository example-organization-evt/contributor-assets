home_env_var="EXAMPLE_ORGANIZATION_HOME"
default_git_authority_path="git@github.com:example-organization-evt"
default_git_branch="master"
default_git_remote_name="origin"

if [ -z "${!home_env_var:-}" ]; then
  printf "\e[31mError: $home_env_var is not set\e[39m\n"
  return 1
fi

PROJECTS_HOME=${PROJECTS_HOME:-${!home_env_var}}
if [ "$PROJECTS_HOME" != "${!home_env_var}" ]; then
  printf "\e[31mError: $PROJECTS_HOME is not set to ${!home_env_var}; exiting unsuccessfully\e[39m"
  return 1
else
  export PROJECTS_HOME
fi

if [ -z "${LIBRARIES_HOME:-}" ]; then
  printf "\e[31mError: LIBRARIES_HOME is not set\e[39m\n"
  return 1
fi

if [ "${GIT_AUTHORITY_PATH:-}" != "$default_git_authority_path" ]; then
  printf "\e[33mWarning: GIT_AUTHORITY_PATH is set: $GIT_AUTHORITY_PATH\e[39m\n"
else
  export GIT_AUTHORITY_PATH="$default_git_authority_path"
fi

if [ "${GIT_REMOTE_NAME:-}" != "$default_git_remote_name" ]; then
  printf "\e[33mWarning: GIT_REMOTE_NAME is set: $GIT_REMOTE_NAME\e[39m\n"
else
  export GIT_REMOTE_NAME="$default_git_remote_name"
fi

if [ "${GIT_DEFAULT_BRANCH:-}" != "$default_git_branch" ]; then
  printf "\e[33mWarning: GIT_DEFAULT_BRANCH is set: $GIT_DEFAULT_BRANCH\e[39m\n"
else
  export GIT_DEFAULT_BRANCH="$default_git_branch"
fi
