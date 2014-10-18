#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
set -x
true
" > actual/test0

printf "\
#! /bin/sh
set -x
true
" > actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0/workdir \
      expected/shutdir/logdir/test1/workdir

printf "+ true\n"   > expected/shutdir/logdir/test0/output
printf "0\n"        > expected/shutdir/logdir/test0/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/test1/output
printf "0\n"        > expected/shutdir/logdir/test1/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/testsfound

printf "\
./test0
./test1
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/testserror

printf "\
================
run: 2 pass: 2 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
