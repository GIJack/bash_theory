#!/bin/bash
#
#  Written for Ninja OS by the development team.
#  licensed under the GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
#

# new switching checker/proccesor example code

switch_checker() {
    while [ ! -z "$1" ];do
        case "$1" in
          --option1)
             ##This is an switch
        
          ;;
          --option2)
              #another switch

          ;;
          --option3)
              #a third switch

          ;;
          *)
              ##This is not a switch, we make the new command line without
              # without switches. counting can be done with ${#}
              PARMS="${PARMS} $1"
          ;;
        esac
        shift
    done

}

# new command line has parameters with switches stripped out, put this in your
# main() function, or whatever else you use
PARMS=""
switch_checker "${@}"
set ${PARMS}

