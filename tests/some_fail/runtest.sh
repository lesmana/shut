#! /bin/sh

set -xeu

testfalse="\
#! /bin/sh
set -x
false
"

testtrue="\
#! /bin/sh
set -x
true
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
run: 3 pass: 2 fail: 1
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
  printf "$testtrue" > test_true1.sh
  printf "$testtrue" > test_true2.sh
  chmod +x test_false1.sh test_true1.sh test_true2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm test_false1.sh test_true1.sh test_true2.sh
)

diff -r expected actual
