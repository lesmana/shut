#! /bin/sh

set -xeu

mkdir -p actual expected/shutdir

printf "\
run: 0 pass: 0 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
