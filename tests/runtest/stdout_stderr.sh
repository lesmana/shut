#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
echo stdout
echo stderr >&2
" > actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test000001/workdir

# prepare test output

printf -- "\
stdout
" > expected/shutdir/test000001/stdout

printf -- "\
stderr
" > expected/shutdir/test000001/stderr

printf -- "\
0
" > expected/shutdir/test000001/exitstatus

# prepare shutdir

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
./test0
" > expected/shutdir/testsrun

printf -- "\
./test0
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
PASS ./test0
stdout:
  stdout
stderr:
  stderr
================
found: 1 run: 1 pass: 1 fail: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -v -x > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r expected actual
