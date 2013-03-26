#! /bin/sh

expectedoutput="\
p ./test_true1.sh
p ./test_true2.sh"
expectedexitstatus=0

output=$(../../butt)
exitstatus=$?

export expectedoutput
export expectedexitstatus
export output
export exitstatus

../common_runtest.sh
