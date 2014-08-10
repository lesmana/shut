#! /bin/sh

set -xeu

shutoutput="\
================
./subdir1/test1
----------------
output:
  $PWD/actual
  $PWD/actual/subdir1/test1
  $PWD/actual/subdir1/test1.dir/workdir
----------------
exitstatus: 0
PASS ./subdir1/test1
----------------
================
./subdir2/subdir21/test21
----------------
output:
  $PWD/actual
  $PWD/actual/subdir2/subdir21/test21
  $PWD/actual/subdir2/subdir21/test21.dir/workdir
----------------
exitstatus: 0
PASS ./subdir2/subdir21/test21
----------------
================
./subdir2/test2
----------------
output:
  $PWD/actual
  $PWD/actual/subdir2/test2
  $PWD/actual/subdir2/test2.dir/workdir
----------------
exitstatus: 0
PASS ./subdir2/test2
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

echo $PWD

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir -p test0.dir/workdir subdir1/test1.dir/workdir subdir2/test2.dir/workdir subdir2/subdir21/test21.dir/workdir
  printf "$testenv" > test0
  printf "$testenv" > subdir1/test1
  printf "$testenv" > subdir2/test2
  printf "$testenv" > subdir2/subdir21/test21
  chmod +x test0 subdir1/test1 subdir2/test2 subdir2/subdir21/test21
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
)

diff -r expected actual
