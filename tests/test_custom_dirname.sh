#! /bin/sh

set -xeu

mkdir -p actual actual/dirname

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/dirname/existingdir

mkdir -p expected/dirname/logdir/test0.dir/workdir

printf "+ true\n"   > expected/dirname/logdir/test0.dir/output
printf "0\n"        > expected/dirname/logdir/test0.dir/exitstatus

printf "\
./test0
" > expected/dirname/tests

printf "\
./test0
" > expected/dirname/pass

printf "\
" > expected/dirname/fail

printf "\
" > expected/dirname/error

printf "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -d dirname > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
