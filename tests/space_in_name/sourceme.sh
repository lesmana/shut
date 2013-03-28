#! /bin/sh

expectedoutput="\
./test false 1.sh
./test true 1.sh
./test true 2.sh"
expectedexitstatus=0

buttcommand="../../butt -n"
