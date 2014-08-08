#! /bin/sh

set -xeu

shutoutput="\
./test_false1.sh
./test_true1.sh
./test_true2.sh
would run: 3
"

shutexitstatus="\
0
"

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
  ../../../shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm test_false1.sh test_true1.sh test_true2.sh
)

diff -r expected actual
