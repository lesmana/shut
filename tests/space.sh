#! /bin/sh

set -xeu

mkdir -p "actual/d 1"

printf -- "\
#! /bin/sh
set -x
false
" > "actual/test 0"

printf -- "\
#! /bin/sh
set -x
true
" > "actual/d 1/test 1"

chmod +x "actual/test 0" "actual/d 1/test 1"

cp -a actual expected

mkdir -p \
      "expected/shutdir/test000002/workdir" \
      "expected/shutdir/test000001/workdir"

printf -- "+ false\n"  > "expected/shutdir/test000002/output"
printf -- "1\n"        > "expected/shutdir/test000002/exitstatus"

printf -- "+ true\n"   > "expected/shutdir/test000001/output"
printf -- "0\n"        > "expected/shutdir/test000001/exitstatus"

printf -- "\
./d 1/test 1
./test 0
" > expected/shutdir/testsfound

printf -- "\
./d 1/test 1
" > expected/shutdir/testspass

printf -- "\
./test 0
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

printf -- "\
================
PASS ./d 1/test 1
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
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "1\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v > stdout 2> stderr
  printf -- "$?\n" > exitstatus
  set -e
)

diff -r expected actual
