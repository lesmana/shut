#! /bin/sh

set -xeu

mkdir -p actual expected

printf -- "\
no tests found
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "2\n" > expected/exitstatus

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
