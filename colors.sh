#!/bin/bash
# Console colors.
# GPLv3 GI Jack

# Console colors are important, as they can make important parts of data pop out
# and differntiate the important data in a wall of text. Its very important
# to have a consistent color scheme of what colors mean in your application.

# The following colors are standard

# error, failure	- bright red
# warning		- bright yellow
# OK, success, pass	- bright cyan
# block devices		- bright yellow
# .img files		- bright green
# GPG keynames		- bright green
# proper names, serials
# versions, etc..	- bright white
# block text		- undeccorated

# Modifiers
BRIGHT=$(tput bold)
NOCOLOR=$(tput sgr0) #reset to default colors

# Regular Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
ORANGE=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
LIGHT_GREY=$(tput setaf 7)
DARK_GREY=$(tput setaf 8)

# Bold Colors - Note they don't all dirrectly correspond to their regular
# counter parts. They are also color codes 9-16 as well
BRIGHT_RED=$(tput setaf 1;tput bold)
BRIGHT_GREEN=$(tput setaf 2;tput bold)
BRIGHT_YELLOW=$(tput setaf 3;tput bold)
BRIGHT_BLUE=$(tput setaf 4;tput bold)
BRIGHT_PINK=$(tput setaf 5;tput bold)
BRIGHT_CYAN=$(tput setaf 6;tput bold)
BRIGHT_WHITE=$(tput setaf 7;tput bold)
MEDIUM_GREY=$(tput setaf 8;tput bold)

# If you are ever in doubt about color codes, this function will show you how
# they are obtained.
enumerate_colors(){
  tput sgr0 #reset to default color
  # there are sixteen colors by default, so using a for loop we can run through
  # then sequentially
  for number in {1..16};do
    tput setaf $number
    echo "color number $number"
  done
  
  tput sgr0
}

