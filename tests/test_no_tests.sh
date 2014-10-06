#! /bin/sh

set -xeu

mkdir -p actual expected

printf "\
no tests found
" > expected/stdout

printf "2\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
