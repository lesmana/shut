#! /bin/sh

set -xeu

mkdir -p actual/d1 actual/d2/d21

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

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $SHUT_TESTPWD
' > actual/d2/test2

printf '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $SHUT_TESTPWD
' > actual/d2/d21/test21

chmod +x \
      actual/test0 \
      actual/d1/test1 \
      actual/d2/test2 \
      actual/d2/d21/test21

cp -a actual expected

printf "\
================
./d1/test1
----------------
output:
  $PWD/actual
  $PWD/actual/d1/test1
  $PWD/actual/shutdir/d1/test1.dir/workdir
----------------
exitstatus: 0
PASS ./d1/test1
----------------
================
./d2/d21/test21
----------------
output:
  $PWD/actual
  $PWD/actual/d2/d21/test21
  $PWD/actual/shutdir/d2/d21/test21.dir/workdir
----------------
exitstatus: 0
PASS ./d2/d21/test21
----------------
================
./d2/test2
----------------
output:
  $PWD/actual
  $PWD/actual/d2/test2
  $PWD/actual/shutdir/d2/test2.dir/workdir
----------------
exitstatus: 0
PASS ./d2/test2
----------------
================
./test0
----------------
output:
  $PWD/actual
  $PWD/actual/test0
  $PWD/actual/shutdir/test0.dir/workdir
----------------
exitstatus: 0
PASS ./test0
----------------
run: 4 pass: 4 fail: 0
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir/test0.dir/workdir \
      expected/shutdir/d1/test1.dir/workdir \
      expected/shutdir/d2/test2.dir/workdir \
      expected/shutdir/d2/d21/test21.dir/workdir

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

printf "\
$PWD/actual
$PWD/actual/d2/test2
$PWD/actual/shutdir/d2/test2.dir/workdir
" > expected/shutdir/d2/test2.dir/output

printf "\
$PWD/actual
$PWD/actual/d2/d21/test21
$PWD/actual/shutdir/d2/d21/test21.dir/workdir
" > expected/shutdir/d2/d21/test21.dir/output

printf "0\n" > expected/shutdir/test0.dir/exitstatus
printf "0\n" > expected/shutdir/d1/test1.dir/exitstatus
printf "0\n" > expected/shutdir/d2/test2.dir/exitstatus
printf "0\n" > expected/shutdir/d2/d21/test21.dir/exitstatus

(
  cd actual
  set +e
  shut -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
