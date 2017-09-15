#!/bin/bash

# These are a few extra utility functions that compliment the finger fingers

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
  local -i success
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
    sudo $@
    ;;
   uid)
    $@
    ;;
  esac
}

# Example code for ROOT_METHOD detection
[ ${can_sudo} != "true" -a $UID -ne 0 ] && ROOT_METHOD="UID"

### ------------------------------------------------------------------------ ###
