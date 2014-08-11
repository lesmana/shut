#! /bin/sh

set -xeu

shutoutput="\
./subdir1/test1
./subdir2/subdir21/test21
./subdir2/test2
./test0
would run: 4
"

shutexitstatus="\
0
"

testtrue="\
#! /bin/sh
set -x
true
"

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
  printf "$testtrue" > test0
  printf "$testtrue" > subdir1/test1
  printf "$testtrue" > subdir2/test2
  printf "$testtrue" > subdir2/subdir21/test21
  chmod +x test0 subdir1/test1 subdir2/test2 subdir2/subdir21/test21
  set +e
  shut -n -r > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm -rf test0 subdir1 subdir2
)

diff -r expected actual
