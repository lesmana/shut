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
FAIL ./test0
exitstatus: 1
output:
  + false
================
PASS ./test1
exitstatus: 0
output:
  + true
================
fail:
./test0
================
run: 2 pass: 1 fail: 1 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "1\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -u -r expected actual
