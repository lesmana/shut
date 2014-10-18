#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
echo stdout
echo stderr >&2
" > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir/test000001/test0/workdir

printf "stdout\n" > expected/shutdir/logdir/test000001/test0/stdout

printf "stderr\n" > expected/shutdir/logdir/test000001/test0/stderr

printf "0\n" > expected/shutdir/logdir/test000001/test0/exitstatus

printf "\
./test0
" > expected/shutdir/testsfound

printf "\
./test0
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/testserror

printf "\
================
PASS ./test0
stdout:
  stdout
stderr:
  stderr
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v -x > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
