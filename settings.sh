home_env_var="EXAMPLE_ORGANIZATION_HOME"
git_authority_path="git@github.com:example-organization-evt"
git_default_branch="master"
git_remote_name="origin"
rubygems_authority_path="http://localhost:8080"
rubygems_authority_access_key="example-organization"

if [ -z "${!home_env_var:-}" ]; then
  printf "\e[31mError: $home_env_var is not set\e[39m\n"
  return 1
fi

if [ -z "${LIBRARIES_HOME:-}" ]; then
  printf "\e[31mError: LIBRARIES_HOME is not set\e[39m\n"
  return 1
fi

if [ "${PROJECTS_HOME:=${!home_env_var}}" != "${!home_env_var}" ]; then
  printf "\e[31mError: $PROJECTS_HOME is not set to ${!home_env_var}; exiting unsuccessfully\e[39m"
  return 1
fi
export PROJECTS_HOME

if [ "${GIT_AUTHORITY_PATH:=$git_authority_path}" != "$git_authority_path" ]; then
  printf "\e[33mWarning: GIT_AUTHORITY_PATH is set: $GIT_AUTHORITY_PATH\e[39m\n"
fi
export GIT_AUTHORITY_PATH

if [ "${GIT_REMOTE_NAME:=$git_remote_name}" != "$git_remote_name" ]; then
  printf "\e[33mWarning: GIT_REMOTE_NAME is set: $GIT_REMOTE_NAME\e[39m\n"
fi
export GIT_REMOTE_NAME

if [ "${GIT_DEFAULT_BRANCH:=$git_default_branch}" != "$git_default_branch" ]; then
  printf "\e[33mWarning: GIT_DEFAULT_BRANCH is set: $GIT_DEFAULT_BRANCH\e[39m\n"
fi
export GIT_DEFAULT_BRANCH

if [ "${RUBYGEMS_AUTHORITY_PATH:=$rubygems_authority_path}" != "$rubygems_authority_path" ]; then
  printf "\e[33mWarning: RUBYGEMS_AUTHORITY_PATH is set: $RUBYGEMS_AUTHORITY_PATH\e[39m\n"
fi
export RUBYGEMS_AUTHORITY_PATH

if [ "${RUBYGEMS_AUTHORITY_ACCESS_KEY:=$rubygems_authority_access_key}" != "$rubygems_authority_access_key" ]; then
  printf "\e[33mWarning: RUBYGEMS_AUTHORITY_ACCESS_KEY is set: $RUBYGEMS_AUTHORITY_ACCESS_KEY\e[39m\n"
fi
export RUBYGEMS_AUTHORITY_ACCESS_KEY
