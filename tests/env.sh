#! /bin/sh

set -xeu

mkdir -p actual/d1

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/test0

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/d1/test1

chmod +x actual/test0 actual/d1/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test0.dir/workdir \
      expected/shutdir/logdir/d1/test1.dir/workdir

printf "\
$PWD/actual
$PWD/actual/test0
$PWD/actual/shutdir/logdir/test0.dir/workdir
" > expected/shutdir/logdir/test0.dir/output

printf "0\n" > expected/shutdir/logdir/test0.dir/exitstatus

printf "\
$PWD/actual
$PWD/actual/d1/test1
$PWD/actual/shutdir/logdir/d1/test1.dir/workdir
" > expected/shutdir/logdir/d1/test1.dir/output

printf "0\n" > expected/shutdir/logdir/d1/test1.dir/exitstatus

printf "\
./d1/test1
./test0
" > expected/shutdir/tests

printf "\
./d1/test1
./test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

printf "\
" > expected/shutdir/error

printf "\
================
run: 2 pass: 2 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
