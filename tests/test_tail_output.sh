#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
seq 1 5
" > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/test0.dir/workdir

printf "\
1
2
3
4
5
" > expected/shutdir/test0.dir/output

printf "0\n" > expected/shutdir/test0.dir/exitstatus

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
output:
  3
  4
  5
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
  shut -v -t 3 > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual