#! /bin/sh

set -xeu

mkdir -p actual

touch actual/foo1 actual/foo2 actual/bar1 actual/bar2 actual/baz1 actual/baz2

chmod +x actual/*

cp -a actual expected

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

(
  cd actual
  shut -n foo bar > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
