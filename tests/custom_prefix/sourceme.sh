#! /bin/sh

expectedoutput="\
./prefix_false1.sh
./prefix_true1.sh
./prefix_true2.sh"
expectedexitstatus=0

buttcommand="../../butt -n prefix"
