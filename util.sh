#!/usr/bin/env bash

# These are a few extra utility functions that compliment the five fingers

DEP_LIST="bash cp rm"
check_deps(){
  #This function checks dependencies. looks for executable binaries in path
  for dep in ${DEP_LIST};do
    which ${dep} &> /dev/null || "$dep is not in \$PATH! This is needed to run. Quitting"
  done
}

round(){
  # Round instead of truncate. needs two vars: scale, and the float you need rounded
  local -i scale=${1}
  local raw_input=${2}
  local -i int=$(cut -d "." -f 1 <<< $raw_input)
  local -i float=$(cut -d "." -f 2 <<< $raw_input)
  local -i keep_n=${float:0:${scale}}
  local -i last_n=${float:0-1}

  if [ $last_n -ge 5 ];then
    keep_n+=1
  fi

  output="${int}"."${keep3}"
  echo "$output"
}

### ------------------------------------------------------------------------ ###

# check_sudo and as_root. check_sudo tests if sudo can be executed by the script
# as_root is a replacement for sudo that accounts for diffrent methods for
# running commands as root. This allows for diffrent end user setups to work
# and the script to be flexible.

# The default option in this case is sudo.
ROOT_METHOD="sudo"

# Checks if this script can run sudo
check_sudo(){
  # Check if this script can run sudo correctly.
  local sudouser=""
  sudouser=$( sudo whoami )
  if [ ${sudouser} == "root" ];then
    echo true
   else
    echo false
  fi
}
# sudo frontent. use sudo if it is selected, if we are running as UID 0, we can
# simply run the command dirrectly. you can add more options here if you have
# your own commands
as_root(){
  # execute a command as root.
  case $ROOT_METHOD in
   sudo)
    sudo ${@}
    ;;
   polkit)
    pkexec ${@}
    ;;
   uid)
    ${@}
    ;;
  esac
}

# Example code for ROOT_METHOD detection
  if [ ${UID} -eq 0 ];then
    ROOT_METHOD="uid"
   elif [ ${can_sudo} == "true" ];then
    ROOT_METHOD="sudo"
   else
    exit_with_error 4 "Cannot gain root! This program needs root to work Exiting..."
  fi

### ------------------------------------------------------------------------ ###
