#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
false
" > actual/test0

printf -- "\
#! /bin/sh
set -x
true
" > actual/test1

printf -- "\
#! /bin/sh
set -x
false
" > actual/test2

printf -- "\
#! /bin/sh
set -x
true
" > actual/test3

chmod +x \
  actual/test0 \
  actual/test1 \
  actual/test2 \
  actual/test3

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test000001/workdir \
  expected/shutdir/test000002/workdir \
  expected/shutdir/test000003/workdir \
  expected/shutdir/test000004/workdir

# prepare test output

printf -- "\
+ false
" > expected/shutdir/test000001/output

printf -- "\
1
" > expected/shutdir/test000001/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000002/output

printf -- "\
0
" > expected/shutdir/test000002/exitstatus

printf -- "\
+ false
" > expected/shutdir/test000003/output

printf -- "\
1
" > expected/shutdir/test000003/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000004/output

printf -- "\
0
" > expected/shutdir/test000004/exitstatus

# prepare shutdir

printf -- "\
./test0
./test1
./test2
./test3
" > expected/shutdir/testsfound

printf -- "\
./test0
./test1
./test2
./test3
" > expected/shutdir/testsrun

printf -- "\
./test1
./test3
" > expected/shutdir/testspass

printf -- "\
./test0
./test2
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
FAIL ./test0
exitstatus: 1
output:
  + false
================
FAIL ./test2
exitstatus: 1
output:
  + false
================
fail:
./test0
./test2
================
found: 4 run: 4 pass: 2 fail: 2
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
1
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r expected actual
