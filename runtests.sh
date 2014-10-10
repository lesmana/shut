#! /bin/sh

PATH=$PWD:$PATH

if [ $# -ne 0 ]; then
  goodshut "$@" tests
else
  goodshut tests
fi
