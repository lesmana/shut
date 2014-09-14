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
./test2
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test2
----------------
run: 4 pass: 2 fail: 2
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir/test0.dir/workdir \
      expected/shutdir/test1.dir/workdir \
      expected/shutdir/test2.dir/workdir \
      expected/shutdir/test3.dir/workdir

printf "+ false\n"  > expected/shutdir/test0.dir/output
printf "1\n"        > expected/shutdir/test0.dir/exitstatus
printf "+ true\n"   > expected/shutdir/test1.dir/output
printf "0\n"        > expected/shutdir/test1.dir/exitstatus
printf "+ false\n"  > expected/shutdir/test2.dir/output
printf "1\n"        > expected/shutdir/test2.dir/exitstatus
printf "+ true\n"   > expected/shutdir/test3.dir/output
printf "0\n"        > expected/shutdir/test3.dir/exitstatus

printf "\
./test0
./test1
./test2
./test3
" > expected/shutdir/tests

printf "\
./test1
./test3
" > expected/shutdir/pass

printf "\
./test0
./test2
" > expected/shutdir/fail

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
