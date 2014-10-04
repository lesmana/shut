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

mkdir -p expected/shutdir/logdir/test0.dir/workdir

printf "stdout\n" > expected/shutdir/logdir/test0.dir/stdout

printf "stderr\n" > expected/shutdir/logdir/test0.dir/stderr

printf "0\n" > expected/shutdir/logdir/test0.dir/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
./test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

printf "\
================
./test0
----------------
stdout:
  stdout
stderr:
  stderr
----------------
exitstatus: 0
PASS ./test0
----------------
run: 1 pass: 1 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -v -x > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
