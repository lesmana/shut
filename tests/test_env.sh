#! /bin/sh

set -xeu

mkdir -p actual/d1

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $SHUT_TESTPWD
' > actual/test0

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $SHUT_TESTPWD
' > actual/d1/test1

chmod +x actual/test0 actual/d1/test1

cp -a actual expected

printf "\
run: 2 pass: 2 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir/test0.dir/workdir \
      expected/shutdir/d1/test1.dir/workdir

printf "\
$PWD/actual
$PWD/actual/test0
$PWD/actual/shutdir/test0.dir/workdir
" > expected/shutdir/test0.dir/output

printf "\
$PWD/actual
$PWD/actual/d1/test1
$PWD/actual/shutdir/d1/test1.dir/workdir
" > expected/shutdir/d1/test1.dir/output

printf "0\n" > expected/shutdir/test0.dir/exitstatus
printf "0\n" > expected/shutdir/d1/test1.dir/exitstatus

printf "\
$SHUT_TESTPWD/actual/d1/test1
$SHUT_TESTPWD/actual/test0
" > expected/shutdir/tests

printf "\
$SHUT_TESTPWD/actual/d1/test1
$SHUT_TESTPWD/actual/test0
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
