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
FAIL ./test0
exitstatus: 2
output:
  + exit 2
================
FAIL ./test1
exitstatus: 64
output:
  + exit 64
================
fail:
./test0
./test1
================
run: 2 pass: 0 fail: 2 error: 0
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

diff -u -r expected actual