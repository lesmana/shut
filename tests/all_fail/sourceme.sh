#! /bin/sh

expectedoutput="\
./test_false1.sh
  + false
./test_false2.sh
  + false"
expectedexitstatus=1

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus
