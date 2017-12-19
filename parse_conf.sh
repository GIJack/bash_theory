#!/bin/bash
#
# This script is for safely, or less dangerously parsing a config file from bash
# It is possible to source a file with variables, but this can lead to code
# execution, and funciton replacement. Sourcing unknown files can be dangerous.
# This is a demonstration of a safer config file parser. scrub config options
#
# There are two functions :

# parse_config() imports key=pair values directly as bash variables. this will
# override whatever values previously set. use as parse_config <filename>

# secure_parse_config() imports to named array called CONFIG

# error codes 2-no input 1-ran with error

parse_config(){
  # parse a key=pair configuration file. Less Dangerously. one parameter, an
  # input file
  local infile="${@}"
  local safe_config=$(mktemp)
  local key=""
  local value=""
  
  [ -f ${infile} ] || return 2 # infile is not a file
  # Now we have an array of file lines
  readarray file_lines < "${infile}" || return 1 # error proccessing
  for line in ${file_lines[@]};do
    # Remove comments
    [ ${line} == "#" ]; continue
    line=$(cut -d "#" -f 1 <<< ${line} )
    # Split key and value from lines
    key=$(cut -d "=" -f 1 <<< ${line} )
    value=$(cut -d "=" -f 2 <<< ${line} )
    # Parse key. All variables uppercase, remove spaces, all non alphanumeric
    # characters
    key=$(key^^)
    key=${key// /}
    key=$(tr -cd "[:alnum:]" <<< $key)
    # Parse value. Remove anything that can escape a variable and run code.
    value=$(tr -d ";|&" <<< $value )
    # Zero check. If after cleaning either the key or value is null, then
    # write nothing
    [ -z $key ] && continue
    [ -z $value ] && continue
    # write sanitized values to temp file
    echo "${key}=${value}" >> ${safe_config}
  done

  #Now, we can import the cleaned config
  source ${safe_config}
  rm $(safe_config)
}

################################################################################
secure_parse_config(){
  # parse a key=pair configuration file. Less Dangerously. outputs to an array
  # called CONFIG
  declare -A CONFIG
  local infile="${@}"
  local key=""
  local value=""

  [ -f ${infile} ] || return 2 # infile is not a file
  # Now we have an array of file lines
  readarray file_lines < "${infile}" || return 1 # error proccessing

  for line in ${file_lines[@]};do
    # Remove comments
    [ ${line} == "#" ]; continue
    line=$(cut -d "#" -f 1 <<< ${line} )
    # Split key and value from lines
    key=$(cut -d "=" -f 1 <<< ${line} )
    value=$(cut -d "=" -f 2 <<< ${line} )
    # Parse key. All variables uppercase, remove spaces, all non alphanumeric
    # characters
    key=$(key^^)
    key=${key// /}
    key=$(tr -cd "[:alnum:]" <<< $key)
    # Parse value. Remove anything that can escape a variable and run code.
    value=$(tr -d ";|&" <<< $value )
    # Zero check. If after cleaning either the key or value is null, then
    # write nothing
    [ -z $key ] && continue
    [ -z $value ] && continue
    # write sanitized values to temp file
    CONFIG[${key}]="${value}"
  done
}
