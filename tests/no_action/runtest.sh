#! /bin/sh

set -x

. ../libruntest.sh

shutcommand_in_actual() {
  ../../../shut -n
}

runtest
