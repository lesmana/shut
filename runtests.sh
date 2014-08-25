#! /bin/sh

PATH=$PATH:$PWD

cd tests
../goodshut -f -l ../runtests.log -r runtest
