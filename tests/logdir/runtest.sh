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
  mkdir -p testf1.sh.dir/workdir testt1.sh.dir/workdir testt2.sh.dir/workdir
  mkdir -p logdir/testf1.sh logdir/testt1.sh logdir/testt2.sh
  printf "$testfalseoutput" > logdir/testf1.sh/output
  printf "$testfalseexitstatus" > logdir/testf1.sh/exitstatus
  printf "$testtrueoutput" > logdir/testt1.sh/output
  printf "$testtrueexitstatus" > logdir/testt1.sh/exitstatus
  printf "$testtrueoutput" > logdir/testt2.sh/output
  printf "$testtrueexitstatus" > logdir/testt2.sh/exitstatus
)

(
  cd actual
  printf "$testfalse" > testf1.sh
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testf1.sh testt1.sh testt2.sh
  set +e
  ../../../shut -l logdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testf1.sh testt1.sh testt2.sh
)

diff -r expected actual
