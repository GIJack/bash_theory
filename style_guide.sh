#!/bin/bash
# This is my style guide. There are many like it, but this one is mine.
# Line one is the shebang. The shebang is always line one, and it always points
# to bash. #!/bin/bash is safe on GNU systems, otherwise #!/usr/bin/env bash
# is safe.

# Why BASH? Because its native to the ever present GNU/Linux system, and its
# been ported to run on everything.

# 1. Comments:
#    Comments lines are done with a comment at the beginning of the line and
#    given one space between text and comment. additional spaces for
#    justification as needed. comments should respect the 80 line margin

# 2. Indents:
#    there are two types of indent, step and half step. A full step is two
#    spaces functions, if/case statements get a full indent. substatements of
#    case and if such as elif and )) are given a half step.
functions(){
  echo "Functions and full statements get a full indent"
  if [ statement ];then
    echo "true"
   elif [ statement ];then
    echo "false"
  fi
  # This is a switching statement
  case ${variable} in
   one)
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

# 4. echo and printing text:
#    echo'ing text generally gets quoted with double "" quotes, unless unable,
#    then gets quoted with '' single quotes.
echo "this is output"

# 5. Functions and variables:
#    Functions shall be named with underscores _ seperating names and be all
#    lower case names. variables used within functions shall use the local
#    function. Variable are preffered with ${1} as opposed to $1.

#    Global variables should be all uppercase, while local variables should be
#    all lower case. for, and any other temporary variable is considered local
#    regardless of context.

GLOBAL_VARIABLE=${1}
my_func(){
  local local_variable="${1}"
  for item in ${GLOBAL_VARIABLE};do
    echo "${item}"
  done
}

# 6. blocks of text:
#    Blocks of text longer than 2-3 lines in length shall be handled by
#    cat << EOF instead of echo. All block text(non-generated) shalled be
#    limited to 80 characters
cat << EOF
This is a block of printed text
the user sees this printed just like this.

This is very useful for help outputs as well as large blocks of output

$GLOBAL_VARIABLE

here
EOF

# 7. Error handling.
#    all error messages shall pipe to STDERR. Its also recommended that larger
#    scripts implement error checking functions see five_fingers.sh. Help text
#    is also considered "error" text and shall be piped to STDERR as well.
echo 1>&2 "error message"

# 8. Main Function.
#    Scripts of any considerable lenghth and complexity shall use a main()
#    function. This will be the last thing in the script except main that calls
#    the script. the function call will always include the ${@} variable to pass
#    all variables to the main function, used or not. The exception to this is
#    if you have a switch handler function that runs before main. If you have a
#    switch handler function, this is run before main() and feeds santized
#    positional parameters to main sans switches which are already global
#    variables

main(){
  echo "main program function"
}
main ${@}
