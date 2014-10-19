#! /bin/sh

set -xeu

mkdir -p actual actual/dirname

printf -- "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

cp -a actual expected

touch actual/dirname/existingdir

mkdir -p expected/dirname/test000001/workdir

printf -- "+ true\n"   > expected/dirname/test000001/output
printf -- "0\n"        > expected/dirname/test000001/exitstatus

printf -- "\
./test0
" > expected/dirname/testsfound

printf -- "\
./test0
" > expected/dirname/testspass

printf -- "\
" > expected/dirname/testsfail

printf -- "\
" > expected/dirname/testserror

printf -- "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "0\n" > expected/exitstatus

(
  cd actual
  shut -d dirname > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
