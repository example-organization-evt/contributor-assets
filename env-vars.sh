remote_authority_path="git@github.com:example-platform-layer"
remote_name="origin"
default_branch="master"

if [ -z "${EXAMPLE_PLATFORM_LAYER_HOME:-}" ]; then
  printf "\n\e[31mError: EXAMPLE_PLATFORM_LAYER_HOME is not set\e[m\n"
  exit 1
fi
projects_home=$EXAMPLE_PLATFORM_LAYER_HOME

if [ -n "${GIT_AUTHORITY_PATH:-}" ]; then
  echo "The GIT_AUTHORITY_PATH environment variable is set: $GIT_AUTHORITY_PATH. It will be used for this script."
  remote_authority_path="$GIT_AUTHORITY_PATH"
fi

if [ -n "${GIT_REMOTE_NAME:-}" ]; then
  echo "The GIT_REMOTE_NAME environment variable is set: $GIT_REMOTE_NAME. It will be used for this script."
  remote_name="$GIT_REMOTE_NAME"
fi

if [ -n "${GIT_DEFAULT_BRANCH:-}" ]; then
  echo "The GIT_DEFAULT_BRANCH environment variable is set: $GIT_DEFAULT_BRANCH. It will be used for this script."
  default_branch="$GIT_DEFAULT_BRANCH"
fi

export projects_home
export remote_authority_path
export remote_name
export default_branch
