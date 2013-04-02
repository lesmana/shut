#! /bin/sh
set -x

. ../common_arrange.sh
. ../common_act.sh
. ../common_assert.sh

after_arrange() {
  rm expected/logdir/gitpleaseindexthisemptydir
}

arrange
after_arrange
act
assert
