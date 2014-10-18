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

mkdir -p expected/dirname/logdir/test0/workdir

printf "+ true\n"   > expected/dirname/logdir/test0/output
printf "0\n"        > expected/dirname/logdir/test0/exitstatus

printf "\
./test0
" > expected/dirname/testsfound

printf "\
./test0
" > expected/dirname/testspass

printf "\
" > expected/dirname/fail

printf "\
" > expected/dirname/error

printf "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -d dirname > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
