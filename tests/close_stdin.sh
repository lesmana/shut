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

set -xeu

mkdir -p actual

printf '\
#! /bin/sh
if read line; then
  echo "got line: $line"
else
  echo "got nothing"
fi
' > actual/test0

printf '\
#! /bin/sh
echo "yay"
' > actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

mkdir -p \
      expected/shutdir/logdir/test000001/test0/workdir \
      expected/shutdir/logdir/test000002/test1/workdir

printf "\
got nothing
" > expected/shutdir/logdir/test000001/test0/output

printf "0\n" > expected/shutdir/logdir/test000001/test0/exitstatus

printf "\
yay
" > expected/shutdir/logdir/test000002/test1/output

printf "0\n" > expected/shutdir/logdir/test000002/test1/exitstatus

printf "\
./test0
./test1
" > expected/shutdir/testsfound

printf "\
./test0
./test1
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/testsfail

printf "\
" > expected/shutdir/testserror

printf "\
================
run: 2 pass: 2 fail: 0 error: 0
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
