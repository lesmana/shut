#! /bin/sh
set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

runtest
