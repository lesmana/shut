#! /bin/sh

set -xeu

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
exit 2
" > actual/test0

printf -- "\
#! /bin/sh
set -x
exit 64
" > actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/test000001/workdir \
      expected/shutdir/test000002/workdir

printf -- "\
+ exit 2
" > expected/shutdir/test000001/output

printf -- "\
2
" > expected/shutdir/test000001/exitstatus

printf -- "\
+ exit 64
" > expected/shutdir/test000002/output

printf -- "\
64
" > expected/shutdir/test000002/exitstatus

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

printf -- "\
================
FAIL ./test0
exitstatus: 2
output:
  + exit 2
================
FAIL ./test1
exitstatus: 64
output:
  + exit 64
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

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
