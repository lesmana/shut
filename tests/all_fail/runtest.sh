#! /bin/sh

set -xeu

testfalse="\
#! /bin/sh
set -x
false
"

shutoutput="\
================
./test_false1.sh
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test_false1.sh
----------------
================
./test_false2.sh
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test_false2.sh
----------------
run: 2 pass: 0 fail: 2
"

shutexitstatus="\
1
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
  printf "$testfalse" > test_false1.sh
  printf "$testfalse" > test_false2.sh
  chmod +x test_false1.sh test_false2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm test_false1.sh test_false2.sh
)

diff -r expected actual
