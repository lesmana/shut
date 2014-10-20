#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual actual/shutdir

touch actual/testtake actual/shutdir/testskip

chmod +x actual/testtake actual/shutdir/testskip

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
./testtake
================
would run: 1
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
