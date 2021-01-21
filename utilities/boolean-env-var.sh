function boolean-env-var {
  variable_name=$1
  default=${2:-no}

  val=${!variable_name:=$default}

  if [[ "n|no|f|false|off|0" =~ $val ]]; then
    echo 'false'
  elif [[ "y|yes|t|true|on|1" =~ $val ]]; then
    echo 'true'
  else
    echo "Environment variable \$$variable_name is set to \`$val' which is not a boolean value" >&2
    echo >&2
    exit 1
  fi
}
