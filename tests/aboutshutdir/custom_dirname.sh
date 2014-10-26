#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual actual/dirname

printf -- "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

touch actual/dirname/existingdir

mkdir -p expected/dirname/test000001/workdir

# prepare test output

printf -- "\
+ true
" > expected/dirname/test000001/output

printf -- "\
0
" > expected/dirname/test000001/exitstatus

# prepare shutdir

printf -- "\
./test0
" > expected/dirname/testsfound

printf -- "\
./test0
" > expected/dirname/testsrun

printf -- "\
./test0
" > expected/dirname/testspass

printf -- "\
" > expected/dirname/testsfail

printf -- "\
" > expected/dirname/testserror

# prepare shut output

printf -- "\
================
run: 1 pass: 1 fail: 0 error: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -d dirname > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
