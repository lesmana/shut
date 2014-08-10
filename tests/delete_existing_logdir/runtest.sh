#! /bin/sh

set -xeu

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
  mkdir test_false1.sh.dir test_true1.sh.dir test_true2.sh.dir
  mkdir -p logdir/test_false1.sh logdir/test_true1.sh logdir/test_true2.sh
  printf "$testfalseoutput" > logdir/test_false1.sh/output
  printf "$testfalseexitstatus" > logdir/test_false1.sh/exitstatus
  printf "$testtrueoutput" > logdir/test_true1.sh/output
  printf "$testtrueexitstatus" > logdir/test_true1.sh/exitstatus
  printf "$testtrueoutput" > logdir/test_true2.sh/output
  printf "$testtrueexitstatus" > logdir/test_true2.sh/exitstatus
)

(
  cd actual
  printf "$testfalse" > test_false1.sh
  printf "$testtrue" > test_true1.sh
  printf "$testtrue" > test_true2.sh
  chmod +x test_false1.sh test_true1.sh test_true2.sh
  mkdir logdir
  touch logdir/existinglogdir
  set +e
  ../../../shut -l logdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm test_false1.sh test_true1.sh test_true2.sh
)

diff -r expected actual
