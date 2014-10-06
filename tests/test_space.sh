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
      "expected/shutdir/logdir/test 0.dir/workdir" \
      "expected/shutdir/logdir/d 1/test 1.dir/workdir"

printf "+ false\n"  > "expected/shutdir/logdir/test 0.dir/output"
printf "1\n"        > "expected/shutdir/logdir/test 0.dir/exitstatus"

printf "+ true\n"   > "expected/shutdir/logdir/d 1/test 1.dir/output"
printf "0\n"        > "expected/shutdir/logdir/d 1/test 1.dir/exitstatus"

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
" > expected/shutdir/error

printf "\
================
PASS ./d 1/test 1
exitstatus: 0
output:
  + true
================
FAIL ./test 0
exitstatus: 1
output:
  + false
================
fail:
./test 0
================
run: 2 pass: 1 fail: 1 error: 0
" > expected/shutoutput

printf "1\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
