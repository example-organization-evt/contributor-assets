set -eu

source ./projects/ruby-projects.sh
source ./projects/template-projects.sh
source ./projects/other-projects.sh

projects=(
  "${other_projects[@]}"
  "${template_projects[@]}"
  "${ruby_projects[@]}"
)
