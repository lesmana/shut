#! /bin/sh

# prepare actual

mkdir -p actual/d1

printf -- '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/test1

printf -- '\
#! /bin/sh
echo $SHUT_PWD
echo $SHUT_TEST
echo $PWD
' > actual/d1/test2

chmod +x actual/test1 actual/d1/test2

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test1/workdir \
  expected/shutdir/d1/test2/workdir

printf -- "\
$PWD/actual
$PWD/actual/test1
$PWD/actual/shutdir/test1/workdir
" > expected/shutdir/test1/stdout

printf -- "\
" > expected/shutdir/test1/stderr

printf -- "\
0
" > expected/shutdir/test1/exitstatus

# prepare test output

printf -- "\
$PWD/actual
$PWD/actual/d1/test2
$PWD/actual/shutdir/d1/test2/workdir
" > expected/shutdir/d1/test2/stdout

printf -- "\
" > expected/shutdir/d1/test2/stderr

printf -- "\
0
" > expected/shutdir/d1/test2/exitstatus

# prepare shutdir

printf -- "\
./d1/test2
./test1
" > expected/shutdir/testsfound

printf -- "\
./d1/test2
./test1
" > expected/shutdir/testsrun

printf -- "\
./d1/test2
./test1
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
found: 2 run: 2 pass: 2 fail: 0
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
)

# compare

diff -r -C 9000 expected actual
