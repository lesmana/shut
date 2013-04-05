#! /bin/sh

set -x

. ../libruntest.sh

after_arrange() {
  rm expected/logdir/existinglogdir
  rm expected/logdir/newlogdir
}

shutcommand_in_actual() {
  ../../../shut -l logdir
}

runtest
