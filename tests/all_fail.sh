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
false
" > actual/test2

chmod +x actual/test1 actual/test2

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test1/workdir \
  expected/shutdir/test2/workdir

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
" > expected/shutdir/test2/stdout

printf -- "\
+ false
" > expected/shutdir/test2/stderr

printf -- "\
1
" > expected/shutdir/test2/exitstatus

# prepare shutdir

printf -- "\
./test1
./test2
" > expected/shutdir/testsfound

printf -- "\
./test1
./test2
" > expected/shutdir/testsrun

printf -- "\
" > expected/shutdir/testspass

printf -- "\
./test1
./test2
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
FAIL ./test1
exitstatus: 1
stdout:
stderr:
  + false
================
FAIL ./test2
exitstatus: 1
stdout:
stderr:
  + false
================
fail:
./test1
./test2
================
found: 2 run: 2 pass: 0 fail: 2
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
