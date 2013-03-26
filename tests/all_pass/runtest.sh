#! /bin/sh

expectedoutput="\
+ true
+ true"
expectedexitstatus=0

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
