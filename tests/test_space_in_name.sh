#! /bin/sh

set -xeu

mkdir -p "actual/d 1"

printf "\
#! /bin/sh
set -x
false
" > "actual/test 0"

printf "\
#! /bin/sh
set -x
true
" > "actual/d 1/test 1"

chmod +x "actual/test 0" "actual/d 1/test 1"

cp -a actual expected

mkdir -p \
      "expected/shutdir/test 0.dir/workdir" \
      "expected/shutdir/d 1/test 1.dir/workdir"

printf "+ false\n"  > "expected/shutdir/test 0.dir/output"
printf "1\n"        > "expected/shutdir/test 0.dir/exitstatus"

printf "+ true\n"   > "expected/shutdir/d 1/test 1.dir/output"
printf "0\n"        > "expected/shutdir/d 1/test 1.dir/exitstatus"

printf "\
./d 1/test 1
./test 0
" > expected/shutdir/tests

printf "\
./d 1/test 1
" > expected/shutdir/pass

printf "\
./test 0
" > expected/shutdir/fail

printf "\
================
./d 1/test 1
----------------
output:
  + true
----------------
exitstatus: 0
PASS ./d 1/test 1
----------------
================
./test 0
----------------
output:
  + false
----------------
exitstatus: 1
FAIL ./test 0
----------------
failed tests:
./test 0
----------------
run: 2 pass: 1 fail: 1
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -v > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
