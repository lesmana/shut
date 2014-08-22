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

testfalseoutput="\
+ false
"

testfalseexitstatus="\
1
"

testtrue="\
#! /bin/sh
set -x
true
"

testtrueoutput="\
+ true
"

testtrueexitstatus="\
0
"

rm -rf expected actual
mkdir expected actual

(
  cd expected
  printf "$shutoutput" > shutoutput
  printf "$shutexitstatus" > shutexitstatus
  mkdir -p logdir
  cd logdir
  mkdir -p testf1.sh.dir/workdir testt1.sh.dir/workdir testt2.sh.dir/workdir
  printf "$testfalseoutput" > testf1.sh.dir/output
  printf "$testfalseexitstatus" > testf1.sh.dir/exitstatus
  printf "$testtrueoutput" > testt1.sh.dir/output
  printf "$testtrueexitstatus" > testt1.sh.dir/exitstatus
  printf "$testtrueoutput" > testt2.sh.dir/output
  printf "$testtrueexitstatus" > testt2.sh.dir/exitstatus
)

(
  cd actual
  printf "$testfalse" > testf1.sh
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testf1.sh testt1.sh testt2.sh
  set +e
  shut -l logdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testf1.sh testt1.sh testt2.sh
)

diff -r expected actual
