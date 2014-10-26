#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/exactname actual/exactnameplusextra actual/othername

chmod +x actual/*

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
./exactname
================
would run: 1
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
) || true

# compare

diff -r expected actual