#! /bin/sh
set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

arrange
after_arrange
act
assert
