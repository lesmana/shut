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
true
" > actual/testt1.sh

printf "\
#! /bin/sh
set -x
true
" > actual/testt2.sh

chmod +x actual/testf1.sh actual/testt1.sh actual/testt2.sh

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
run: 3 pass: 2 fail: 1
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

mkdir -p expected/shutdir

mkdir -p \
      expected/shutdir \
      expected/shutdir/testf1.sh.dir/workdir \
      expected/shutdir/testt1.sh.dir/workdir \
      expected/shutdir/testt2.sh.dir/workdir

printf "+ false\n"  > expected/shutdir/testf1.sh.dir/output
printf "1\n"        > expected/shutdir/testf1.sh.dir/exitstatus
printf "+ true\n"   > expected/shutdir/testt1.sh.dir/output
printf "0\n"        > expected/shutdir/testt1.sh.dir/exitstatus
printf "+ true\n"   > expected/shutdir/testt2.sh.dir/output
printf "0\n"        > expected/shutdir/testt2.sh.dir/exitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
