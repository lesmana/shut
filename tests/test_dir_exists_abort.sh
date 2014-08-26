#! /bin/sh

set -xeu

shutoutput="\
name exists: logdir
will not overwrite
use -f to overwrite
"

shutexitstatus="\
1
"

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir logdir
  touch logdir/existinglogdir
)

(
  cd actual
  mkdir logdir
  touch logdir/existinglogdir
  set +e
  shut -l logdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
