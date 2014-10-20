#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual actual/shutdir

printf -- "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

touch actual/shutdir/existingdir

mkdir -p expected/shutdir/test000001/workdir

# prepare test output

printf -- "\
+ true
" > expected/shutdir/test000001/output

printf -- "\
0
" > expected/shutdir/test000001/exitstatus

# prepare shutdir

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
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
