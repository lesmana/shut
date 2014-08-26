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
  mkdir -p shutdir
  cd shutdir
  mkdir -p testt1.sh.dir/workdir testt2.sh.dir/workdir
  printf "$testtrueoutput" > testt1.sh.dir/output
  printf "$testtrueexitstatus" > testt1.sh.dir/exitstatus
  printf "$testtrueoutput" > testt2.sh.dir/output
  printf "$testtrueexitstatus" > testt2.sh.dir/exitstatus
)

(
  cd actual
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testt1.sh testt2.sh
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testt1.sh testt2.sh
)

diff -r expected actual
