#! /bin/sh

# prepare actual

mkdir -p actual

printf -- '\
#! /bin/sh
{ echo foo >&3 ; } 2> /dev/null || echo fd3 closed
{ echo foo >&4 ; } 2> /dev/null || echo fd4 closed
' > actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test1/workdir

# prepare test output

printf -- "\
fd3 closed
fd4 closed
" > expected/shutdir/test1/output

printf -- "\
0
" > expected/shutdir/test1/exitstatus

# prepare shutdir

printf -- "\
./test1
" > expected/shutdir/testsfound

printf -- "\
./test1
" > expected/shutdir/testsrun

printf -- "\
./test1
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
PASS ./test1
output:
  fd3 closed
  fd4 closed
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
  shut -v > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
