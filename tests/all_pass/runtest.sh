#! /bin/sh

expectedoutput="\
"
expectedexitstatus=0

output="$(../../butt)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
