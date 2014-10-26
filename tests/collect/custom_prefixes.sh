#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/foo1 actual/foo2 actual/bar1 actual/bar2 actual/baz1 actual/baz2

chmod +x actual/*

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
./bar1
./bar2
./foo1
./foo2
================
would run: 4
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
0
" > expected/exitstatus

# run shut

(
  cd actual
  shut -n foo bar > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual