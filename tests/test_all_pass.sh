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
      expected/shutdir/logdir/test0.dir/workdir \
      expected/shutdir/logdir/test1.dir/workdir

printf "+ true\n"   > expected/shutdir/logdir/test0.dir/output
printf "0\n"        > expected/shutdir/logdir/test0.dir/exitstatus

printf "+ true\n"   > expected/shutdir/logdir/test1.dir/output
printf "0\n"        > expected/shutdir/logdir/test1.dir/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/tests

printf "\
./test0
./test1
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

printf "\
run: 2 pass: 2 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
