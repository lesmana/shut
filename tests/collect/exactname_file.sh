#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/exactname actual/exactnameplusextra actual/othername

chmod +x actual/*

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./exactname
================
found: 1 run: 0 pass: 0 fail: 0
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n exactname > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
