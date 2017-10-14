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
  "expected/shutdir/test 0/workdir" \
  "expected/shutdir/d 1/test 1/workdir"

# prepare test output

printf -- "\
" > "expected/shutdir/test 0/stdout"

printf -- "\
+ false
" > "expected/shutdir/test 0/stderr"

printf -- "\
1
" > "expected/shutdir/test 0/exitstatus"

printf -- "\
" > "expected/shutdir/d 1/test 1/stdout"

printf -- "\
+ true
" > "expected/shutdir/d 1/test 1/stderr"

printf -- "\
0
" > "expected/shutdir/d 1/test 1/exitstatus"

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
stdout:
stderr:
  + true
================
FAIL ./test 0
exitstatus: 1
stdout:
stderr:
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
)

# compare

diff -r -C 9000 expected actual
