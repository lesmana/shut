#! /bin/sh

expectedoutput="\
"
expectedexitstatus=0

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus