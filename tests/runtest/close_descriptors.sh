#! /bin/sh

# prepare actual

mkdir -p actual

printf -- '\
#! /bin/sh
{ echo foo >&3 ; } 2> /dev/null || echo fd3 closed
{ echo foo >&4 ; } 2> /dev/null || echo fd4 closed
{ echo foo >&5 ; } 2> /dev/null || echo fd5 closed
{ echo foo >&6 ; } 2> /dev/null || echo fd6 closed
{ echo foo >&7 ; } 2> /dev/null || echo fd7 closed
{ echo foo >&8 ; } 2> /dev/null || echo fd8 closed
{ echo foo >&9 ; } 2> /dev/null || echo fd9 closed
' > actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test1/workdir

# prepare test output

printf -- "\
fd3 closed
fd4 closed
fd5 closed
fd6 closed
fd7 closed
fd8 closed
fd9 closed
" > expected/shutdir/test1/stdout

printf -- "\
" > expected/shutdir/test1/stderr

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
" > expected/shutdir/testserror

printf -- "\
./test1
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
TEST ./test1
stdout:
  fd3 closed
  fd4 closed
  fd5 closed
  fd6 closed
  fd7 closed
  fd8 closed
  fd9 closed
stderr:
PASS ./test1
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
