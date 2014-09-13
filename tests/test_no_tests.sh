#! /bin/sh

set -xeu

mkdir -p actual expected/shutdir

printf "\
no tests found
" > expected/shutoutput

printf "3\n" > expected/shutexitstatus

touch expected/shutdir/mktempfilename

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
