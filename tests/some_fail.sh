#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
set -x
false
" > actual/test1

printf -- "\
#! /bin/sh
set -x
true
" > actual/test2

printf -- "\
#! /bin/sh
set -x
false
" > actual/test3

printf -- "\
#! /bin/sh
set -x
true
" > actual/test4

chmod +x \
  actual/test1 \
  actual/test2 \
  actual/test3 \
  actual/test4

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test000001/test1/workdir \
  expected/shutdir/test000002/test2/workdir \
  expected/shutdir/test000003/test3/workdir \
  expected/shutdir/test000004/test4/workdir

# prepare test output

printf -- "\
+ false
" > expected/shutdir/test000001/test1/output

printf -- "\
1
" > expected/shutdir/test000001/test1/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000002/test2/output

printf -- "\
0
" > expected/shutdir/test000002/test2/exitstatus

printf -- "\
+ false
" > expected/shutdir/test000003/test3/output

printf -- "\
1
" > expected/shutdir/test000003/test3/exitstatus

printf -- "\
+ true
" > expected/shutdir/test000004/test4/output

printf -- "\
0
" > expected/shutdir/test000004/test4/exitstatus

# prepare shutdir

printf -- "\
./test1
./test2
./test3
./test4
" > expected/shutdir/testsfound

printf -- "\
./test1
./test2
./test3
./test4
" > expected/shutdir/testsrun

printf -- "\
./test2
./test4
" > expected/shutdir/testspass

printf -- "\
./test1
./test3
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
FAIL ./test1
exitstatus: 1
output:
  + false
================
FAIL ./test3
exitstatus: 1
output:
  + false
================
fail:
./test1
./test3
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

diff -r -C 9000 expected actual
