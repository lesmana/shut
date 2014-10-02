#! /bin/sh

PATH=$PATH:$PWD

if [ $# -ne 0 ]; then
  cd tests
  ../goodshut "$@"
else
  cd tests
  ../goodshut
fi
