#! /bin/sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

../common_arrange.sh
after_arrange
../common_act.sh
../common_assert.sh
