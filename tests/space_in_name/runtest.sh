#! /bin/sh

set -xeu

shutoutput="\
./test false 1.sh
./test true 1.sh
./test true 2.sh
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
  printf "$testfalse" > "test false 1.sh"
  printf "$testtrue" > "test true 1.sh"
  printf "$testtrue" > "test true 2.sh"
  chmod +x "test false 1.sh" "test true 1.sh" "test true 2.sh"
  set +e
  ../../../shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm "test false 1.sh" "test true 1.sh" "test true 2.sh"
)

diff -r expected actual
