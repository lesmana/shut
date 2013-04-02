#! /bin/sh

set -x

. ../libruntest.sh

shutcommand_in_actual() {
  ../../../shut -d logdir
}

runtest
