#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1 actual/test2

chmod +x actual/test1 actual/test2

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./test1
./test2
================
found: 2 run: 0 pass: 0 fail: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
