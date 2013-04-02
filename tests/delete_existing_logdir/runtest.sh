#! /bin/sh
set -x

. ../common_arrange.sh
. ../common_act.sh
. ../common_assert.sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

arrange
after_arrange
act
assert
