#! /bin/sh

set -xeu

shutoutput="\
================
./testf1.sh
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./testf1.sh
----------------
================
./testf2.sh
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./testf2.sh
----------------
run: 2 pass: 0 fail: 2
"

shutexitstatus="\
1
"

testfalse="\
#! /bin/sh
set -x
false
"

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir -p testf1.sh.dir/workdir testf2.sh.dir/workdir
)

(
  cd actual
  printf "$testfalse" > testf1.sh
  printf "$testfalse" > testf2.sh
  chmod +x testf1.sh testf2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testf1.sh testf2.sh
)

diff -r expected actual
