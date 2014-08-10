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
  mkdir -p testt1.sh.dir/workdir testt2.sh.dir/workdir
)

(
  cd actual
  printf "$testtrue" > testt1.sh
  printf "$testtrue" > testt2.sh
  chmod +x testt1.sh testt2.sh
  set +e
  ../../../shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm testt1.sh testt2.sh
)

diff -r expected actual
