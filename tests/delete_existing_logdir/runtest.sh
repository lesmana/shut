#! /bin/sh
set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

arrange
after_arrange
act
assert
