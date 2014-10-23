#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
false
" > actual/test0

printf -- "\
#! /bin/sh
set -x
false
" > actual/test1

chmod +x actual/test0 actual/test1

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
+ false
" > expected/shutdir/test000002/output

printf -- "\
1
" > expected/shutdir/test000002/exitstatus

# prepare shutdir

printf -- "\
./test0
./test1
" > expected/shutdir/testsfound

printf -- "\
" > expected/shutdir/testspass

printf -- "\
./test0
./test1
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

# prepare shut output

printf -- "\
================
FAIL ./test0
exitstatus: 1
output:
  + false
================
FAIL ./test1
exitstatus: 1
output:
  + false
================
fail:
./test0
./test1
================
run: 2 pass: 0 fail: 2 error: 0
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
