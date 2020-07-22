#!/usr/bin/env bash
#
#  GI_Jack. Example options checker.

# SCRIPT DEFAULTS

# the CONFIG is an associative array. You can use simple text variables as well
# Showing off some BASH4 features
declare -A CONFIG
declare PARMS=""

switch_checker() {
  # This function checks generates a useable configuration as an array and
  # filters out --switches and their values leaving just unswitched paramters.
  # Its important not to run any real code here, and just set variables. The
  # exception being help_and_exit() which simply prints help text and exits.
  while [ ! -z "$1" ];do
   case "$1" in
    --help|-\?)
     # Help and Exit. This switch does nothing, but call the help_and_exit
     # routine. see five_fingers.sh
     help_and_exit
     ;;
    --switch-option|-s)
     # This is a switch option, its boolean. Presence of the switch sets it.
     CONFIG[SWITCH]=true  
     ;;
    --text-option|-t)
     # This is a text option. The next parameter is the value. You will notice
     # the shift after the text variable removes the value, and the shift at the
     # bottom of the loop removes the option
     CONFIG[TEXT]="${2}"
     shift
     ;;
    *)
     # This is not a switch, we add all non switch parameters to $PARAMS and
     # then when we run main(), its fed to main() as if it were the command line
     PARMS+="${1}"
     ;;
   esac
   shift
  done
}

main(){
  #example main program
  true
}

# new command line has parameters with switches stripped out, put this before
# your main() function
switch_checker "${@}"
main ${PARMS}
