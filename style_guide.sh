#!/usr/bin/env bash
#
# This is my style guide. There are many like it, but this one is mine.
#
# Line one is the shebang. The shebang is always line one, and it always points
# to bash. #!/usr/bin/env bash should be used, unless the script is written for
# a specific system with no intent of portability

# Why BASH? Because its native to the ever present GNU/Linux system, and its
# been ported to run on everything.
# - GI_Jack

# 1. Comments:
#    Comments lines are done with a comment at the beginning of the line and
#    given one space between # and commend. additional spaces for justification
#    as needed. comments should respect the 80 line margin.

# 2. Indents:
#    there are two types of indent, step and half step. A full step is two
#    spaces functions, if/case statements get a full indent. substatements of
#    case and if such as elif and case switches are given a half step.

# 3. Exit Codes:
#
#   Exit codes are specified with the exit command. exit N. Where N is an INT
#   that is between 0 and 255. This is the scheme I use:
#
#   0 - Success		   : Program ran with no errors. NOTE: Anything other
#                            than a 0 will count as a failure with software and
#			     scripts that check for errors.
#
#   1 - Operational Error  : The script ran, and the proccess failed.
#
#   2 - Conditional Error  : The script ran, but had the wrong start conditions.
#			     Either sanity checks failed, inputs where missing
#                            or of the wrong type, the script was ran by the
#			     wrong user, or in the wrong network or otherwise
#			     wrong conditions. Script exits instead of running.
#
#   4 - help		  : the program printed block text with instructions and
#			    exited. No proccessing of any kind was done, save
#			    figuring out that help_and_exit needs to be run.
#			    help messages should be printed to STDERR under
#			    most circumstances.

functions(){
  echo "Functions and full statements get a full indent"
  if [ statement ];then #then statement is placed on the same line as if
    echo "true"
   elif [ statement ];then # half-step for the elif
    echo "false"
  fi
  # This is a switching statement
  case ${variable} in
   one) #This is half stepped
    echo "this is case one"
    ;;
   two)
    echo "this is case two"
    ;;
   *)
    echo "this is everything else"
    ;;
  esac
}

# 3. if/case/while/for statements:
#    then shall be placed on the same line as the if statement with a semi-colon
#    if, and fi shall be the same indentation, with else and elif one half step
#    indented, see above. same is true for loops and ;do.

VARIABLE="ONE TWO THREE FOUR"
loop_statement(){
  for item in $VARIABLE;do
    echo "item"
  done
}

# 4. echo and printing text:
#    echo'ing text generally gets quoted with double "" quotes, unless unable,
#    then gets quoted with '' single quotes. Any redirect goes before the text
echo "this is output"

# 5. Functions and variables:
#    Functions shall be named with underscores _ seperating names and be all
#    lower case names. variables used within functions shall use the local
#    function. Variable are preffered with ${1} as opposed to $1.

#    Global variables should be all uppercase, while local variables should be
#    all lower case. for loops, and any other temporary variable is considered
#    local regardless of context.

#    All variables shall be declared at the top of their relivant structure
#    Locals at the top of their function, globals at the top of the script.

#    There shall be a space between the () and the { in functions

GLOBAL_VARIABLE=${1}
my_func() {
  local local_variable="${1}"
  for item in ${GLOBAL_VARIABLE};do
    echo "${item}"
  done
}

# 6. Block Text
#    Blocks of text longer than 2-3 lines in length shall be handled by
#    cat << EOF instead of echo. Block Text should be manually formatted with
#    Newlines to respect the 80 character list
cat << EOF
This is a block of printed text
the user sees this printed just like this.

This is very useful for help outputs as well as large blocks of output

$GLOBAL_VARIABLE

here
EOF

# 7. Error handling and use of STDERR.
#    all error messages shall pipe to STDERR. Its also recommended that larger
#    scripts implement error checking functions see five_fingers.sh. Help text
#    is also considered "error" text and shall be piped to STDERR as well.
#    Redirrect should be before the output text.
echo 1>&2 "error message"

# 8. Main Function.
#    Scripts that consist of more than one function and/or 20 lines long shall
#    use a main() function. This will be the last thing in the script except
#    main that calls the script. the function call will always include the ${@}
#    variable to pass all variables to the main function, used or not. The
#    exception to this is if you have a switch handler function that runs before
#    main. If you have a switch handler function, this is run before main() and
#    feeds santized positional parameters to main sans switches which are
#    already global variables

main(){
  echo "main program function"
}
main ${@}
