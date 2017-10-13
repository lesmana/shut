#! /bin/sh

# prepare actual

mkdir -p actual/d1 actual/d2/d3

printf -- "\
#! /bin/sh
set -x
false
" > actual/d1/test2

printf -- "\
#! /bin/sh
set -x
true
" > actual/d2/d3/test4

chmod +x actual/d1/test2 actual/d2/d3/test4

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/d1/test2/workdir \
  expected/shutdir/d2/d3/test4/workdir

# prepare test output

printf -- "\
+ false
" > expected/shutdir/d1/test2/output

printf -- "\
1
" > expected/shutdir/d1/test2/exitstatus

printf -- "\
+ true
" > expected/shutdir/d2/d3/test4/output

printf -- "\
0
" > expected/shutdir/d2/d3/test4/exitstatus

# prepare shutdir

printf -- "\
./d1/test2
./d2/d3/test4
" > expected/shutdir/testsfound

printf -- "\
./d1/test2
./d2/d3/test4
" > expected/shutdir/testsrun

printf -- "\
./d2/d3/test4
" > expected/shutdir/testspass

printf -- "\
./d1/test2
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
FAIL ./d1/test2
exitstatus: 1
output:
  + false
================
fail:
./d1/test2
================
found: 2 run: 2 pass: 1 fail: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
1
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
