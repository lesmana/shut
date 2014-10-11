#! /bin/sh

set -xeu

mkdir -p actual

printf '\
#! /bin/sh
echo foo >&3
' > actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir/test0.dir/workdir

printf "\
$PWD/actual/test0: 3: 3: Bad file descriptor
" > expected/shutdir/logdir/test0.dir/output

printf "2\n" > expected/shutdir/logdir/test0.dir/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
" > expected/shutdir/pass

printf "\
./test0
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
FAIL ./test0
exitstatus: 2
output:
  $PWD/actual/test0: 3: 3: Bad file descriptor
================
fail:
./test0
================
run: 1 pass: 0 fail: 1 error: 0
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