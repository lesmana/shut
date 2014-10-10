#! /bin/sh

PATH=$PWD:$PATH

if [ $# -ne 0 ]; then
  cd tests
  ../goodshut "$@"
else
  cd tests
  ../goodshut
fi
