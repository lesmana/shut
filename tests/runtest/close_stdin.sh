#! /bin/sh

# test that stdin is closed.
#
# the first test will try to read from stdin.
# if successfull the second test will not be run.
# it should not be successfull.
#
# background:
# in shut the testnames are redirected over stdin to a while loop
# reading the names one by one.
# if stdin is not closed then the tests will inherit the open stdin.
# if a test reads from stdin shut will be missing testnames.

# prepare actual

mkdir -p actual

printf -- '\
#! /bin/sh
if read line; then
  echo "got line: $line"
else
  echo "got nothing"
fi
' > actual/test1

printf -- '\
#! /bin/sh
echo "yay"
' > actual/test2

chmod +x actual/test1 actual/test2

# prepare expected

cp -a actual expected

mkdir -p \
  expected/shutdir/test1/workdir \
  expected/shutdir/test2/workdir

# prepare test output

printf -- "\
got nothing
" > expected/shutdir/test1/stdout

printf -- "\
" > expected/shutdir/test1/stderr

printf -- "\
0
" > expected/shutdir/test1/exitstatus

printf -- "\
yay
" > expected/shutdir/test2/stdout

printf -- "\
" > expected/shutdir/test2/stderr

printf -- "\
0
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
" > expected/shutdir/testserror

printf -- "\
./test1
./test2
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
