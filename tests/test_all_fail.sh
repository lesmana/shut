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
false
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
  + false
----------------
exitstatus: 1
FAIL ./test1
----------------
run: 2 pass: 0 fail: 2
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir/test0.dir/workdir \
      expected/shutdir/test1.dir/workdir

printf "+ false\n"  > expected/shutdir/test0.dir/output
printf "1\n"        > expected/shutdir/test0.dir/exitstatus
printf "+ false\n"  > expected/shutdir/test1.dir/output
printf "1\n"        > expected/shutdir/test1.dir/exitstatus

printf "\
$SHUT_TESTPWD/actual/test0
$SHUT_TESTPWD/actual/test1
" > expected/shutdir/tests

printf "\
" > expected/shutdir/pass

printf "\
$SHUT_TESTPWD/actual/test0
$SHUT_TESTPWD/actual/test1
" > expected/shutdir/fail

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
