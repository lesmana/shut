#! /bin/sh

set -xeu

mkdir -p actual

printf '\
#! /bin/sh
{ echo foo >&3 ; } 2> /dev/null || echo fd3 closed
{ echo foo >&4 ; } 2> /dev/null || echo fd4 closed
' > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir/test0/workdir

printf "\
fd3 closed
fd4 closed
" > expected/shutdir/logdir/test0/output

printf "0\n" > expected/shutdir/logdir/test0/exitstatus

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
PASS ./test0
output:
  fd3 closed
  fd4 closed
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
