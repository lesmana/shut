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

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0.dir/workdir \
      expected/shutdir/logdir/test1.dir/workdir

printf "+ false\n"  > expected/shutdir/logdir/test0.dir/output
printf "1\n"        > expected/shutdir/logdir/test0.dir/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/test1.dir/output
printf "0\n"        > expected/shutdir/logdir/test1.dir/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/tests

printf "\
./test1
" > expected/shutdir/pass

printf "\
./test0
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
./test0
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test0
================
./test1
----------------
output:
  + true
----------------
exitstatus: 0
PASS ./test1
================
fail:
./test0
================
run: 2 pass: 1 fail: 1 error: 0
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
