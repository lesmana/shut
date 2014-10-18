#! /bin/sh

set -xeu

mkdir -p actual

printf '\
#! /bin/sh
echo test0
chmod -x $(dirname $SHUT_TEST)/test1
' > actual/test0

printf '\
#! /bin/sh
echo test1
' > actual/test1

printf '\
#! /bin/sh
echo test2
' > actual/test2

chmod +x actual/test0 actual/test1 actual/test2

cp -a actual expected

mkdir -p \
      expected/shutdir/test000001/test0/workdir \
      expected/shutdir/test000002 \
      expected/shutdir/test000003/test2/workdir

printf "test0\n"  > expected/shutdir/test000001/test0/output
printf "0\n"      > expected/shutdir/test000001/test0/exitstatus

printf "test2\n"  > expected/shutdir/test000003/test2/output
printf "0\n"      > expected/shutdir/test000003/test2/exitstatus

printf "\
./test0
./test1
./test2
" > expected/shutdir/testsfound

printf "\
./test0
./test2
" > expected/shutdir/testspass

printf "\
" > expected/shutdir/testsfail

printf "\
./test1
" > expected/shutdir/testserror

printf "\
================
PASS ./test0
output:
  test0
================
ERROR ./test1
not found or not executable: ./test1
================
PASS ./test2
output:
  test2
================
error:
./test1
================
run: 3 pass: 2 fail: 0 error: 1
" > expected/stdout

printf "\
" > expected/stderr

printf "1\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -v > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
