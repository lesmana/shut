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
      expected/shutdir/test000002/test0/workdir \
      expected/shutdir/test000001/d1/test1/workdir

printf "\
$PWD/actual
$PWD/actual/test0
$PWD/actual/shutdir/test000002/test0/workdir
" > expected/shutdir/test000002/test0/output

printf "0\n" > expected/shutdir/test000002/test0/exitstatus

printf "\
$PWD/actual
$PWD/actual/d1/test1
$PWD/actual/shutdir/test000001/d1/test1/workdir
" > expected/shutdir/test000001/d1/test1/output

printf "0\n" > expected/shutdir/test000001/d1/test1/exitstatus

printf "\
./d1/test1
./test0
" > expected/shutdir/testsfound

printf "\
./d1/test1
./test0
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/testserror

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
