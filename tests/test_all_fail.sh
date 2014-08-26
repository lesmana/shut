#! /bin/sh

set -xeu

mkdir actual

printf "\
#! /bin/sh
set -x
false
" > actual/testf1.sh

printf "\
#! /bin/sh
set -x
false
" > actual/testf2.sh

chmod +x actual/testf1.sh actual/testf2.sh

cp -a actual expected

printf "\
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
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

mkdir -p \
      expected/shutdir \
      expected/shutdir/testf1.sh.dir/workdir \
      expected/shutdir/testf2.sh.dir/workdir

printf "+ false\n"  > expected/shutdir/testf1.sh.dir/output
printf "1\n"        > expected/shutdir/testf1.sh.dir/exitstatus
printf "+ false\n"  > expected/shutdir/testf2.sh.dir/output
printf "1\n"        > expected/shutdir/testf2.sh.dir/exitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
