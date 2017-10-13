#! /bin/sh

# prepare actual

mkdir -p actual

printf -- "\
#! /bin/sh
seq 1 5
" > actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test000001/test1/workdir

# prepare test output

printf -- "\
1
2
3
4
5
" > expected/shutdir/test000001/test1/output

printf -- "\
0
" > expected/shutdir/test000001/test1/exitstatus

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
  3
  4
  5
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
  shut -v -t 3 > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
