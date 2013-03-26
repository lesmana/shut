#! /bin/sh

expectedoutput="\
./test false 1.sh
  + false"
expectedexitstatus=1

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
