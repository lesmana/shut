#! /bin/sh

set -xeu

mkdir -p actual

printf -- "\
#! /bin/sh
seq 1 5
" > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/test000001/workdir

printf -- "\
1
2
3
4
5
" > expected/shutdir/test000001/output

printf -- "\
0
" > expected/shutdir/test000001/exitstatus

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
./test0
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

printf -- "\
================
PASS ./test0
output:
  3
  4
  5
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

(
  cd actual
  shut -v -t 3 > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
