#! /bin/sh

set -xeu

mkdir -p actual expected

printf "\
no tests found
" > expected/stdout

printf "\
" > expected/stderr

printf "2\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -u -r expected actual
