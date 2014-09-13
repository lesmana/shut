#! /bin/sh

set -xeu

mkdir actual

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

printf "\
================
./test0
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test0
----------------
================
./test1
----------------
output:
  + true
----------------
exitstatus: 0
PASS ./test1
----------------
run: 2 pass: 1 fail: 1
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir/test0.dir/workdir \
      expected/shutdir/test1.dir/workdir

printf "+ false\n"  > expected/shutdir/test0.dir/output
printf "1\n"        > expected/shutdir/test0.dir/exitstatus
printf "+ true\n"   > expected/shutdir/test1.dir/output
printf "0\n"        > expected/shutdir/test1.dir/exitstatus

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

(
  cd actual
  set +e
  shut -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
