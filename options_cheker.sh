#!/bin/bash
#
#  GI_Jack. Example options checker.

switch_checker() {
  while [ ! -z "$1" ];do
   case "$1" in
    --option1|-a)
     ##This is an switch  
     true
     ;;
    --option2|-b)
     #another switch
     true
     ;;
    --option3|-c)
     #a third switch
     true
     ;;
    *)
     ##This is not a switch, we make the new command line without
     # without switches. counting can be done with ${#}
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
PARMS=""
switch_checker "${@}"
#set ${PARMS}
main ${PARAMS}
