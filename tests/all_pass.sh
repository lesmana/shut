#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
true
" > actual/test1

printf -- "\
#! /bin/sh
set -x
true
" > actual/test2

chmod +x actual/test1 actual/test2

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test000001/test1/workdir \
  expected/shutdir/test000002/test2/workdir

# prepare test output

printf -- "\
+ true
" > expected/shutdir/test000001/test1/output

printf -- "\
0
" > expected/shutdir/test000001/test1/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000002/test2/output

printf -- "\
0
" > expected/shutdir/test000002/test2/exitstatus

# prepare shutdir

printf -- "\
./test1
./test2
" > expected/shutdir/testsfound

printf -- "\
./test1
./test2
" > expected/shutdir/testsrun

printf -- "\
./test1
./test2
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
found: 2 run: 2 pass: 2 fail: 0
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
