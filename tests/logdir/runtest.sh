#! /bin/sh

set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

shutcommand_in_actual() {
  ../../../shut -l logdir
}

runtest
