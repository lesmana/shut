#! /bin/sh

expectedoutput="\
./test_false1.sh
  + false"
expectedexitstatus=1

output="$(../../butt 2>&1)"
exitstatus=$?
