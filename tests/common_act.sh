#! /bin/sh

(cd actual; ../shutcommand.sh > output 2>&1; echo $? > exitstatus)
