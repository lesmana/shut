#! /bin/sh

expectedoutput="\
./prefix_false1.sh
  + false"
expectedexitstatus=1

output="$(../../butt prefix 2>&1)"
exitstatus=$?
