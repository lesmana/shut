#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test_exec actual/test_notexec

chmod +x actual/test_exec

cp -a actual expected

printf -- "\
./test_exec
================
would run: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "0\n" > expected/exitstatus

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
