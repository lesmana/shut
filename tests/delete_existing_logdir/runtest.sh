#! /bin/sh
set -x

. ../common_runtest.sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

arrange
after_arrange
act
assert
