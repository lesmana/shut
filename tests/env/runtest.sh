#! /bin/sh

set -xeu

shutoutput="\
================
./subdir1/test1
----------------
output:
  $PWD/actual
  ./subdir1/test1
  $PWD/actual/subdir1
----------------
exitstatus: 0
PASS ./subdir1/test1
----------------
================
./subdir2/subdir21/test21
----------------
output:
  $PWD/actual
  ./subdir2/subdir21/test21
  $PWD/actual/subdir2/subdir21
----------------
exitstatus: 0
PASS ./subdir2/subdir21/test21
----------------
================
./subdir2/test2
----------------
output:
  $PWD/actual
  ./subdir2/test2
  $PWD/actual/subdir2
----------------
exitstatus: 0
PASS ./subdir2/test2
----------------
================
./test0
----------------
output:
  $PWD/actual
  ./test0
  $PWD/actual
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

echo $PWD

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
)

(
  cd actual
  mkdir -p subdir1 subdir2/subdir21
  printf "$testenv" > test0
  printf "$testenv" > subdir1/test1
  printf "$testenv" > subdir2/test2
  printf "$testenv" > subdir2/subdir21/test21
  chmod +x test0 subdir1/test1 subdir2/test2 subdir2/subdir21/test21
  set +e
  ../../../shut -r -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm -rf test0 subdir1 subdir2
)

diff -r expected actual
