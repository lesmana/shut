#! /bin/sh

PATH=$PATH:$PWD

cd tests
../goodshut -l ../runtests.log -r runtest
