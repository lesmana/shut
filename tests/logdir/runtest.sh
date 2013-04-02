#! /bin/sh
set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

runtest
