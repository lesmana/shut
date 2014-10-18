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
true
" > actual/test1

printf "\
#! /bin/sh
set -x
false
" > actual/test2

printf "\
#! /bin/sh
set -x
true
" > actual/test3

chmod +x \
      actual/test0 \
      actual/test1 \
      actual/test2 \
      actual/test3

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0/workdir \
      expected/shutdir/logdir/test1/workdir \
      expected/shutdir/logdir/test2/workdir \
      expected/shutdir/logdir/test3/workdir

printf "+ false\n"  > expected/shutdir/logdir/test0/output
printf "1\n"        > expected/shutdir/logdir/test0/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/test1/output
printf "0\n"        > expected/shutdir/logdir/test1/exitstatus

printf "+ false\n"  > expected/shutdir/logdir/test2/output
printf "1\n"        > expected/shutdir/logdir/test2/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/test3/output
printf "0\n"        > expected/shutdir/logdir/test3/exitstatus

printf "\
./test0
./test1
./test2
./test3
" > expected/shutdir/testsfound

printf "\
./test1
./test3
" > expected/shutdir/testspass

printf "\
./test0
./test2
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
FAIL ./test2
exitstatus: 1
output:
  + false
================
fail:
./test0
./test2
================
run: 4 pass: 2 fail: 2 error: 0
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
