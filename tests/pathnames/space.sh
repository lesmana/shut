#! /bin/sh

# prepare actual

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

# prepare expected

cp -a actual expected

mkdir -p \
  "expected/shutdir/test000002/workdir" \
  "expected/shutdir/test000001/workdir"

# prepare test output

printf -- "\
+ false
" > "expected/shutdir/test000002/output"

printf -- "\
1
" > "expected/shutdir/test000002/exitstatus"

printf -- "\
+ true
" > "expected/shutdir/test000001/output"

printf -- "\
0
" > "expected/shutdir/test000001/exitstatus"

# prepare shutdir

printf -- "\
./d 1/test 1
./test 0
" > expected/shutdir/testsfound

printf -- "\
./d 1/test 1
./test 0
" > expected/shutdir/testsrun

printf -- "\
./d 1/test 1
" > expected/shutdir/testspass

printf -- "\
./test 0
" > expected/shutdir/testsfail

# prepare shut output

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
found: 2 run: 2 pass: 1 fail: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
1
" > expected/exitstatus

# run shut

(
  cd actual
  shut -v > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
