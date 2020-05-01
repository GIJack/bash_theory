#!/usr/bin/env bash

# The point of these 5 functions is to give a bash script a consistant feel,
# and make scripting more joyful.

# The "Five Finger Death Punch" is my answer to the three finger claw.
# https://gist.github.com/dotike/8257326 - three finger claw.

# The three finger claw is insuffiecient and does not solve use case scenarios.
# Kudos for implementing "try" in sh, but its very static in what it does.
# Its very hakui like elegant, again, which lights up the brains of UNIX people.

# But GNU is not UNIX. the Five Finger Death Punch is not UNIX, but GNU.

# It is not important to implement all five fingers. Generally the big three
# are exit_with_error, message and help_and_exit

# It should be noted that all help and error messages need to be piped to
# STDERR, something not in the claw. help messages should be considered errors
# because you don't want it to get sucked into piped output but instead tell
# them they are doing something wrong, which often the help message does.(i.e.
# null parameters == help on some scripts)

# Try solves no use cases that should use || exit_with_error instead. this is
# closer to python who's try command has an except to handle exceptions.

#Help and and exit. Should be explanitory. Big note, use cat <<EOF instead of
# echo

# GI_Jack Licensed under the LGPLv3
help_and_exit(){
  cat 1>&2 << EOF
five_fingers.sh:

This script is an example of the five finger death punch.

EOF
  exit 1
}

# communicate with the user
message(){
  echo "five_fingers: ${@}"
}

# secondary text for styling purposes. adjust spacing, type of spacing, etc...
submsg(){
  echo "	${@}"
}

# oh noes, something went wrong exit_with_error exitcode "message"
exit_with_error(){
  echo 1>&2 "five_fingers.sh: ERROR: ${2}"
  exit ${1}
}

# Something broke, but script continues.
warn(){
  echo 1>&2 "five_fingers.sh: WARN: ${@}"
}


