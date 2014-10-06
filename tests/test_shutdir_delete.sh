#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/shutdir/existingdir

mkdir -p expected/shutdir/logdir/test0.dir/workdir

printf "+ true\n"   > expected/shutdir/logdir/test0.dir/output
printf "0\n"        > expected/shutdir/logdir/test0.dir/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
./test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
