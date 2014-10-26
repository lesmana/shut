#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual/d1 actual/d2/d3

printf -- "\
#! /bin/sh
set -x
false
" > actual/d1/test1

printf -- "\
#! /bin/sh
set -x
true
" > actual/d2/d3/test3

chmod +x actual/d1/test1 actual/d2/d3/test3

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test000001/workdir \
  expected/shutdir/test000002/workdir

# prepare test output

printf -- "\
+ false
" > expected/shutdir/test000001/output

printf -- "\
1
" > expected/shutdir/test000001/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000002/output

printf -- "\
0
" > expected/shutdir/test000002/exitstatus

# prepare shutdir

printf -- "\
./d1/test1
./d2/d3/test3
" > expected/shutdir/testsfound

printf -- "\
./d1/test1
./d2/d3/test3
" > expected/shutdir/testsrun

printf -- "\
./d2/d3/test3
" > expected/shutdir/testspass

printf -- "\
./d1/test1
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

# prepare shut output

printf -- "\
================
FAIL ./d1/test1
exitstatus: 1
output:
  + false
================
fail:
./d1/test1
================
run: 2 pass: 1 fail: 1 error: 0
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
) || true

# compare

diff -r expected actual
