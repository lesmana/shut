#! /bin/sh

set -xeu

mkdir -p actual/d1 actual/d2/d3

printf "\
#! /bin/sh
set -x
false
" > actual/d1/test1

printf "\
#! /bin/sh
set -x
true
" > actual/d2/d3/test3

chmod +x actual/d1/test1 actual/d2/d3/test3

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/d1/test1/workdir \
      expected/shutdir/logdir/d2/d3/test3/workdir

printf "+ false\n"  > expected/shutdir/logdir/d1/test1/output
printf "1\n"        > expected/shutdir/logdir/d1/test1/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/d2/d3/test3/output
printf "0\n"        > expected/shutdir/logdir/d2/d3/test3/exitstatus

printf "\
./d1/test1
./d2/d3/test3
" > expected/shutdir/testsfound

printf "\
./d2/d3/test3
" > expected/shutdir/testspass

printf "\
./d1/test1
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/testserror

printf "\
================
FAIL ./d1/test1
exitstatus: 1
output:
  + false
================
fail:
./d1/test1
================
run: 2 pass: 1 fail: 1 error: 0
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
