#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual/d1

printf -- '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/test0

printf -- '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/d1/test1

chmod +x actual/test0 actual/d1/test1

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test000002/workdir \
  expected/shutdir/test000001/workdir

printf -- "\
$PWD/actual
$PWD/actual/test0
$PWD/actual/shutdir/test000002/workdir
" > expected/shutdir/test000002/output

printf -- "\
0
" > expected/shutdir/test000002/exitstatus

# prepare test output

printf -- "\
$PWD/actual
$PWD/actual/d1/test1
$PWD/actual/shutdir/test000001/workdir
" > expected/shutdir/test000001/output

printf -- "\
0
" > expected/shutdir/test000001/exitstatus

# prepare shutdir

printf -- "\
./d1/test1
./test0
" > expected/shutdir/testsfound

printf -- "\
./d1/test1
./test0
" > expected/shutdir/testsrun

printf -- "\
./d1/test1
./test0
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

# prepare shut output

printf -- "\
================
found: 2 run: 2 pass: 2 fail: 0 error: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
