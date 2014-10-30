#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0 actual/test1

chmod +x actual/test0 actual/test1

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test0
./test1
================
found: 2
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
