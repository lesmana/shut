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
      expected/shutdir/logdir/d1/test1.dir/workdir \
      expected/shutdir/logdir/d2/d3/test3.dir/workdir

printf "+ false\n"  > expected/shutdir/logdir/d1/test1.dir/output
printf "1\n"        > expected/shutdir/logdir/d1/test1.dir/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/d2/d3/test3.dir/output
printf "0\n"        > expected/shutdir/logdir/d2/d3/test3.dir/exitstatus

printf "\
./d1/test1
./d2/d3/test3
" > expected/shutdir/tests

printf "\
./d2/d3/test3
" > expected/shutdir/pass

printf "\
./d1/test1
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
./d1/test1
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./d1/test1
----------------
fail:
./d1/test1
----------------
================
run: 2 pass: 1 fail: 1 error: 0
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
