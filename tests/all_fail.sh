#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
set -x
false
" > actual/test0

printf "\
#! /bin/sh
set -x
false
" > actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0/workdir \
      expected/shutdir/logdir/test1/workdir

printf "+ false\n"  > expected/shutdir/logdir/test0/output
printf "1\n"        > expected/shutdir/logdir/test0/exitstatus

printf "+ false\n"  > expected/shutdir/logdir/test1/output
printf "1\n"        > expected/shutdir/logdir/test1/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/testsfound

printf "\
" > expected/shutdir/testspass

printf "\
./test0
./test1
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
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

printf "\
" > expected/stderr

printf "1\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
