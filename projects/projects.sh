set -eu

source ./projects/ruby-projects.sh
source ./projects/other-projects.sh

projects=(
  "${other_projects[@]}"
  "${ruby_projects[@]}"
)
