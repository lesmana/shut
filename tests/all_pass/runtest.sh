#! /bin/sh

set -xeu

shutoutput="\
run: 2 pass: 2 fail: 0
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
  printf "$testtrue" > test_true1.sh
  printf "$testtrue" > test_true2.sh
  chmod +x test_true1.sh test_true2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm test_true1.sh test_true2.sh
)

diff -r expected actual
