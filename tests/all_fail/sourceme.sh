#! /bin/sh

expectedoutput="\
================
fail: ./test_false1.sh
exitstatus: 1
output:
  + false
----------------
================
fail: ./test_false2.sh
exitstatus: 1
output:
  + false
----------------"

expectedexitstatus=1

buttcommand="../../butt"
