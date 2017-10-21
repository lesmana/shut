#! /bin/sh

# prepare actual

mkdir -p actual actual/dirname

touch actual/dirname/testsfound

printf -- "\
#! /bin/sh
set -x
true
" > actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

touch actual/dirname/existingdir

mkdir -p expected/dirname/test1/workdir

# prepare test output

printf -- "\
" > expected/dirname/test1/stdout

printf -- "\
+ true
" > expected/dirname/test1/stderr

printf -- "\
0
" > expected/dirname/test1/exitstatus

# prepare shutdir

printf -- "\
./test1
" > expected/dirname/testsfound

printf -- "\
./test1
" > expected/dirname/testsrun

printf -- "\
" > expected/dirname/testserror

printf -- "\
./test1
" > expected/dirname/testspass

printf -- "\
" > expected/dirname/testsfail

# prepare shut output

printf -- "\
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
  shut -d dirname > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
