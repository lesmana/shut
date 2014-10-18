#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
set -x
exit 2
" > actual/test0

printf "\
#! /bin/sh
set -x
exit 64
" > actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0/workdir \
      expected/shutdir/logdir/test1/workdir

printf "+ exit 2\n"   > expected/shutdir/logdir/test0/output
printf "2\n"          > expected/shutdir/logdir/test0/exitstatus

printf "+ exit 64\n"  > expected/shutdir/logdir/test1/output
printf "64\n"         > expected/shutdir/logdir/test1/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/testsfound

printf "\
" > expected/shutdir/testspass

printf "\
./test0
./test1
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/error

printf "\
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
