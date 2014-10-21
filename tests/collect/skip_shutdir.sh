#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

touch actual/testtake actual/shutdir/testskip

chmod +x actual/testtake actual/shutdir/testskip

cp -a actual expected

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

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
