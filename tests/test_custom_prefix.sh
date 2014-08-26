#! /bin/sh

set -xeu

shutoutput="\
./prefix_false1.sh
./prefix_true1.sh
./prefix_true2.sh
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
  mkdir shutdir
)

(
  cd actual
  printf "$testfalse" > prefix_false1.sh
  printf "$testtrue" > prefix_true1.sh
  printf "$testtrue" > prefix_true2.sh
  chmod +x prefix_false1.sh prefix_true1.sh prefix_true2.sh
  set +e
  shut -n prefix > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
  rm prefix_false1.sh prefix_true1.sh prefix_true2.sh
)

diff -r expected actual
