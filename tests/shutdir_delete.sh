#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

printf -- "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/shutdir/existingdir

mkdir -p expected/shutdir/test000001/workdir

printf -- "+ true\n"   > expected/shutdir/test000001/output
printf -- "0\n"        > expected/shutdir/test000001/exitstatus

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
./test0
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

printf -- "\
" > expected/shutdir/testserror

printf -- "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
  set -e
)

diff -r expected actual
