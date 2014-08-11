#! /bin/sh

set -xeu

shutoutput="\
================
./d1/test1
----------------
output:
  $PWD/actual
  $PWD/actual/d1/test1
  $PWD/actual/d1/test1.dir/workdir
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
  $PWD/actual/d2/d21/test21.dir/workdir
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
  $PWD/actual/d2/test2.dir/workdir
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
  $PWD/actual/test0.dir/workdir
----------------
exitstatus: 0
PASS ./test0
----------------
run: 4 pass: 4 fail: 0
"

shutexitstatus="\
0
"

testenv='\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $SHUT_TESTPWD
'

test0output="\
$PWD/actual
$PWD/actual/test0
$PWD/actual/test0.dir/workdir
"

test1output="\
$PWD/actual
$PWD/actual/d1/test1
$PWD/actual/d1/test1.dir/workdir
"
test2output="\
$PWD/actual
$PWD/actual/d2/test2
$PWD/actual/d2/test2.dir/workdir
"
test21output="\
$PWD/actual
$PWD/actual/d2/d21/test21
$PWD/actual/d2/d21/test21.dir/workdir
"

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir -p test0.dir/workdir d1/test1.dir/workdir d2/test2.dir/workdir d2/d21/test21.dir/workdir
  printf "$testenv" > test0
  printf "$testenv" > d1/test1
  printf "$testenv" > d2/test2
  printf "$testenv" > d2/d21/test21
  chmod +x test0 d1/test1 d2/test2 d2/d21/test21
  printf "$test0output" > test0.dir/output
  printf "$test1output" > d1/test1.dir/output
  printf "$test2output" > d2/test2.dir/output
  printf "$test21output" > d2/d21/test21.dir/output
  printf "0\n" > test0.dir/exitstatus
  printf "0\n" > d1/test1.dir/exitstatus
  printf "0\n" > d2/test2.dir/exitstatus
  printf "0\n" > d2/d21/test21.dir/exitstatus
)

(
  cd actual
  mkdir -p d1 d2/d21
  printf "$testenv" > test0
  printf "$testenv" > d1/test1
  printf "$testenv" > d2/test2
  printf "$testenv" > d2/d21/test21
  chmod +x test0 d1/test1 d2/test2 d2/d21/test21
  set +e
  shut -r -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
