#! /bin/sh

arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

../common_arrange.sh
arrange
../common_act.sh
../common_assert.sh
