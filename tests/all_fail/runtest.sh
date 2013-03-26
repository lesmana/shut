#! /bin/sh

expectedoutput="\
f ./test_false1.sh
f ./test_false2.sh"
expectedexitstatus=1

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
