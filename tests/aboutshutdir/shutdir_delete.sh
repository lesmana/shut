#! /bin/sh

# prepare actual

mkdir -p actual actual/shutdir

printf -- "\
#! /bin/sh
set -x
true
" > actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

touch actual/shutdir/existingdir

mkdir -p expected/shutdir/test1/workdir

# prepare test output

printf -- "\
" > expected/shutdir/test1/stdout

printf -- "\
+ true
" > expected/shutdir/test1/stderr

printf -- "\
0
" > expected/shutdir/test1/exitstatus

# prepare shutdir

printf -- "\
./test1
" > expected/shutdir/testsfound

printf -- "\
./test1
" > expected/shutdir/testsrun

printf -- "\
./test1
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
found: 1 run: 1 pass: 1 fail: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
