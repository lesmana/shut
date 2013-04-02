#! /bin/sh

arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

../common_arrange.sh
arrange
../common_act.sh
../common_assert.sh
