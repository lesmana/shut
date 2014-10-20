#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual expected

# prepare shut output

printf -- "\
no tests found
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
2
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
