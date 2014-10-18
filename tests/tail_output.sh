#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
seq 1 5
" > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir/test0/workdir

printf "\
1
2
3
4
5
" > expected/shutdir/logdir/test0/output

printf "0\n" > expected/shutdir/logdir/test0/exitstatus

printf "\
./test0
" > expected/shutdir/testsfound

printf "\
./test0
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
PASS ./test0
output:
  3
  4
  5
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v -t 3 > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
