#! /bin/sh

set -xeu

shutoutput="\
./testf1.sh
./testt1.sh
./testt2.sh
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
  printf "$testfalse" > testf1.sh
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testf1.sh testt1.sh testt2.sh
  set +e
  ../../../shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testf1.sh testt1.sh testt2.sh
)

diff -r expected actual
