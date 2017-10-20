#! /bin/sh

# prepare actual

mkdir -p actual/exactdir actual/exactdirplus

touch actual/exactdir/x actual/exactdir/n actual/exactdirplus/x actual/x

chmod +x actual/exactdir/x actual/exactdirplus/x actual/x

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./exactdir/x
================
found: 1 run: 0 pass: 0 fail: 0
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
)

# compare

diff -r -C 9000 expected actual
