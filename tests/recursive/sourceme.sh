#! /bin/sh

expectedoutput="\
./subdir1/test1
./subdir2/subdir21/test21
./subdir2/test2
./test0"
expectedexitstatus=0

buttcommand="../../butt -n -r"
