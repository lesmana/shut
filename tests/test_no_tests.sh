#! /bin/sh

set -xeu

mkdir -p actual expected

printf "\
no tests found
" > expected/shutoutput

printf "2\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
