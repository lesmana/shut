#! /bin/sh

# prepare actual

mkdir -p actual

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir

touch expected/shutdir/testsfound
touch expected/shutdir/testsrun
touch expected/shutdir/testspass
touch expected/shutdir/testsfail
touch expected/shutdir/testserror

# prepare shut output

printf -- "\
================
found: 0 run: 0 pass: 0 fail: 0
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
)

# compare

diff -r -C 9000 expected actual
