#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual/exactdir actual/exactdirplus

touch actual/exactdir/x actual/exactdir/n actual/exactdirplus/x actual/x

chmod +x actual/exactdir/x actual/exactdirplus/x actual/x

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
./exactdir/x
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
  shut -n exactdir > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
