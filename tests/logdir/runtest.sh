#! /bin/sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

../common_arrange.sh
after_arrange
../common_act.sh
../common_assert.sh
