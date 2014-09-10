#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
echo stdout
echo stderr >&2
" > actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
================
./test0
----------------
output:
  stdout
  stderr
----------------
exitstatus: 0
PASS ./test0
----------------
run: 1 pass: 1 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir/test0.dir/workdir

printf "stdout\n" > expected/shutdir/test0.dir/stdout

printf "stderr\n" > expected/shutdir/test0.dir/stderr

printf "0\n" > expected/shutdir/test0.dir/exitstatus

printf "\
$SHUT_TESTPWD/actual/test0
" > expected/shutdir/tests

printf "\
$SHUT_TESTPWD/actual/test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

(
  cd actual
  set +e
  shut -v -x > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
