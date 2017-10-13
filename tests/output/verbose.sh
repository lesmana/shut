#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
false
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
  expected/shutdir/test1/workdir \
  expected/shutdir/test2/workdir

# prepare test output

printf -- "\
+ false
" > expected/shutdir/test1/output

printf -- "\
1
" > expected/shutdir/test1/exitstatus

printf -- "\
+ true
" > expected/shutdir/test2/output

printf -- "\
0
" > expected/shutdir/test2/exitstatus

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
./test2
" > expected/shutdir/testspass

printf -- "\
./test1
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
FAIL ./test1
exitstatus: 1
output:
  + false
================
PASS ./test2
output:
  + true
================
fail:
./test1
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
  shut -v > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
