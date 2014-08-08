#! /bin/sh

set -xeu

shutoutput="\
run: 4 pass: 4 fail: 0
"

shutexitstatus="\
0
"

testpwd="\
#! /bin/sh
set -x
touch \$0.pwd
"

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir -p subdir1 subdir2/subdir21
  printf "$testpwd" > test0
  printf "$testpwd" > subdir1/test1
  printf "$testpwd" > subdir2/test2
  printf "$testpwd" > subdir2/subdir21/test21
  touch test0.pwd subdir1/test1.pwd subdir2/test2.pwd \
        subdir2/subdir21/test21.pwd
)

(
  cd actual
  mkdir -p subdir1 subdir2/subdir21
  printf "$testpwd" > test0
  printf "$testpwd" > subdir1/test1
  printf "$testpwd" > subdir2/test2
  printf "$testpwd" > subdir2/subdir21/test21
  chmod +x test0 subdir1/test1 subdir2/test2 subdir2/subdir21/test21
  set +e
  ../../../shut -r > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
