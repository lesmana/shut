#! /bin/sh

expectedoutput="\
+ false
f ./test_false1.sh
+ false
f ./test_false2.sh"
expectedexitstatus=1

output="$(../../butt 2>&1)"
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
