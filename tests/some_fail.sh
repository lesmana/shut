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
  expected/shutdir/test1/workdir \
  expected/shutdir/test2/workdir \
  expected/shutdir/test3/workdir \
  expected/shutdir/test4/workdir

# prepare test output

printf -- "\
" > expected/shutdir/test1/stdout

printf -- "\
+ false
" > expected/shutdir/test1/stderr

printf -- "\
1
" > expected/shutdir/test1/exitstatus

printf -- "\
================
TEST ./test1
stdout:
stderr:
  + false
exitstatus: 1
FAIL ./test1
" > expected/shutdir/test1/report

printf -- "\
" > expected/shutdir/test2/stdout

printf -- "\
+ true
" > expected/shutdir/test2/stderr

printf -- "\
0
" > expected/shutdir/test2/exitstatus

printf -- "\
================
TEST ./test2
stdout:
stderr:
  + true
PASS ./test2
" > expected/shutdir/test2/report

printf -- "\
" > expected/shutdir/test3/stdout

printf -- "\
+ false
" > expected/shutdir/test3/stderr

printf -- "\
1
" > expected/shutdir/test3/exitstatus

printf -- "\
================
TEST ./test3
stdout:
stderr:
  + false
exitstatus: 1
FAIL ./test3
" > expected/shutdir/test3/report

printf -- "\
" > expected/shutdir/test4/stdout

printf -- "\
+ true
" > expected/shutdir/test4/stderr

printf -- "\
0
" > expected/shutdir/test4/exitstatus

printf -- "\
================
TEST ./test4
stdout:
stderr:
  + true
PASS ./test4
" > expected/shutdir/test4/report

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
" > expected/shutdir/testserror

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
TEST ./test1
stdout:
stderr:
  + false
exitstatus: 1
FAIL ./test1
================
TEST ./test3
stdout:
stderr:
  + false
exitstatus: 1
FAIL ./test3
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
