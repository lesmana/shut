#! /bin/sh

set -x

. ../libruntest.sh

shutcommand_in_actual() {
  ../../../shut -l logdir
}

runtest
