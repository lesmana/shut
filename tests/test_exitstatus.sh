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
      expected/shutdir/logdir/test0.dir/workdir \
      expected/shutdir/logdir/test1.dir/workdir

printf "+ exit 2\n"   > expected/shutdir/logdir/test0.dir/output
printf "2\n"          > expected/shutdir/logdir/test0.dir/exitstatus

printf "+ exit 64\n"  > expected/shutdir/logdir/test1.dir/output
printf "64\n"         > expected/shutdir/logdir/test1.dir/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/tests

printf "\
" > expected/shutdir/pass

printf "\
./test0
./test1
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
./test0
----------------
output:
  + exit 2
----------------
exitstatus: 2
FAIL ./test0
----------------
================
./test1
----------------
output:
  + exit 64
----------------
exitstatus: 64
FAIL ./test1
----------------
fail:
./test0
./test1
----------------
run: 2 pass: 0 fail: 2 error: 0
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
