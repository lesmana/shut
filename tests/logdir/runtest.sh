#! /bin/sh
set -x

. ../common_runtest.sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

arrange
after_arrange
act
assert
