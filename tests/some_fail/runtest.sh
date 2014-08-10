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
run: 3 pass: 2 fail: 1
"

shutexitstatus="\
1
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
  mkdir -p testf1.sh.dir/workdir testt1.sh.dir/workdir testt2.sh.dir/workdir
)

(
  cd actual
  printf "$testfalse" > testf1.sh
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testf1.sh testt1.sh testt2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testf1.sh testt1.sh testt2.sh
)

diff -r expected actual
