#!/bin/bash
#
# These two functions are for parse settings and configuration files. The first
# "parse_enviroment()", parses a shell enviroment file, a text file with a set
# of key=value instructions that are loaded as shell variables in the current
# script. The second "parse_config()", loads the same into a bash array called
# "CONFIG"
#
# These functions santize inputs and respect the "#" comment character.
#
# There are two functions :

# parse_enviroment() - is to parse an enviroment variable file, after scrubbing
#			sanitizing inputs. It is a drop in replacement for
#			source. NOTE: all variables will be made uppercase.
#	Usage:
#	parse_enviroment [file]

# parse_config() -	parses a key=value value config into an named array named
#			config after sanitizing data. the default name for the
#			array is CONFIG, although it can be specified. This
#			strips all non alphanumer characters from the key, and
#			removes	escaping characters from the the value.
#	Usage:
#	parse_config [file]

# error codes 2-no input 1-ran with error 0-ran successfully

parse_enviroment(){
  # parse a key=pair shell enviroment file. NOTE all keys will be made UPPERCASE
  # variables. in parent script.

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

    # Parse key. Make the Key uppercase, remove spaces and all non-alphanumeric
    # characters
    key=$(key^^)
    key=${key// /}
    key=$(tr -cd "[:alnum:]" <<< $key)

    # Parse value. Remove anything that can escape a variable and run code.
    value=$(tr -d ";|&()" <<< $value )

    # Zero check. If after cleaning either the key or value is null, then
    # write nothing
    [ -z $key ] && continue
    [ -z $value ] && continue

    # write sanitized values to temp file
    echo "${key}=${value}" >> ${safe_config}
  done

  #Now, we can import the cleaned config and then delete it.
  source ${safe_config}
  rm $(safe_config)
}

################################################################################
parse_config(){
  # parse a key=pair configuration file into an array called CONFIG.
  local array_name=
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
    key=${key// /}
    key=$(tr -cd "[:alnum:]" <<< $key)
    # Parse value. Remove anything that can escape a variable and run code.
    value=$(tr -d ";|&" <<< $value )
 
   # Zero check. If after cleaning either the key or value is null, then
    # do nothing
    [ -z $key ] && continue
    [ -z $value ] && continue

    # Enter sanitized values to array "CONFIG"
    CONFIG["${key}"]="${value}"
  done
}
