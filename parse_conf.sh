#!/usr/bin/env bash

# error codes:
# 2-no/bad input
# 1-ran with error
# 0-ran successfully

#
# These two functions are for parse settings and configuration files. The goal
# is to santize input from config/default files to prevent end user from running
# untrusted code as the shell. It should be noted that in general, shell should
# never be considered "safe", however this makes parsing configuration files
# safer by blocking chances to run code, and only parsing variables.
#
# This requires GNU Bash explicitly.
#
# "#" is respected as the comment character, like shell.
#
# There are two functions :

# parse_environment() -	returns variables into the running script
#
#			This is a "safer" way to parse an enviroment variable
#			file. It will protect from functions being run and
#			escapes in variables used to run code. Shell is never
#			considered to be "safe", but this is safer than merely
#			running "source" on a potentially unknown file.
#			
#			This will import all shell variables in the file into
#			the running shell/script, but will strip all functions
#			and not execute any code. Designed for compatibility
#			with "source" and use with default files that need this
#
#			NOTE: all variables will be made UPPERCASE, and all
#			spaces and escape ";|&()" characters are stripped
#
#			This should be acceptable if parsing a sysadmin
#			configured "default" file.
#
#	Usage:
#	parse_enviroment [file]
#
# parse_config() -	Parses config into an associative array named $CONFIG,
#			with every key=value pair loaded into the array.
#
#			Keys are limited to alphanumeric characters and
#			everything else is stripped.
#
#			In the value, ";|&()" characters are stripped, and
#			everything else is kept.
#
#			Case sensativity in both cases is retained
#
#	Usage:
#	parse_config [file]


parse_environment(){
  # parse a key=pair shell enviroment file. NOTE all keys will be made UPPERCASE
  # variables. in parent script.

  local infile="${@}"
  local safe_config=$(mktemp)
  local key=""
  local value=""

  
  [ -f "${infile}" ] || return 2 # infile is not a file
  # Now we have an array of file lines
  readarray file_lines < "${infile}" || return 1 # error proccessing

  for line in "${file_lines[@]}";do
    # Remove comments
    [[ -z "{$line}" || "${line}" == "#" ]] && continue
    line=$(cut -d "#" -f 1 <<< ${line} )

    # Split key and value from lines
    key=$(cut -d "=" -f 1 <<< ${line} )
    value=$(cut -d "=" -f 2 <<< ${line} )

    # Parse key. Make the Key uppercase, remove spaces and all non-alphanumeric
    # characters
    key="${key^^}"
    key="${key// /}"
    key="$(tr -cd "[:alnum:]" <<< $key)"

    # Parse value. Remove anything that can escape a variable and run code.
    value="$(tr -d ";|&()" <<< $value )"

    # Zero check. If after cleaning either the key or value is null, then
    # write nothing
    [ -z "${key}" ] && continue
    [ -z "${value}" ] && continue

    # write sanitized values to temp file
    echo "${key}=${value}" >> ${safe_config}
  done

  #Now, we can import the cleaned config and then delete it.
  source ${safe_config}
  rm -f ${safe_config}
}

################################################################################
parse_config(){
  # parse a key=pair configuration file into an array called CONFIG.
  declare -A CONFIG
  local infile="${@}"
  local key=""
  local value=""
  local -a file_lines
  local line=""

  [ -f ${infile} ] || return 2 # infile is not a file
  # Now we have an array of file lines
  readarray file_lines < "${infile}" || return 1 # error proccessing

  for line in "${file_lines[@]}";do
    # Remove comments
    [[ -z "${line}" || "${line}" == "#" ]] && continue
    line="$(cut -d "#" -f 1 <<< ${line} )"

    # Split key and value from lines
    key="$(cut -d "=" -f 1 <<< ${line} )"
    value="$(cut -d "=" -f 2 <<< ${line} )"

    # Parse key. Alphanumeric keys only
    key="${key// /}"
    key="$(tr -cd "[:alnum:]" <<< $key)"
    # Parse value. Remove anything that can escape a variable and run code.
    value="$(tr -d ";|&" <<< $value )"
 
    # Zero check. If after cleaning either the key or value is null, then
    # do nothing
    [ -z "${key}" ] && continue
    [ -z "${value}" ] && continue

    # Enter sanitized values to array "CONFIG"
    CONFIG["${key}"]="${value}"
  done
}
