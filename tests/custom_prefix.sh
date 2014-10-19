#! /bin/sh

set -xeu

mkdir -p actual

touch actual/prefix0 actual/prefix1 actual/notprefix

chmod +x actual/prefix0 actual/prefix1 actual/notprefix

cp -a actual expected

printf -- "\
./prefix0
./prefix1
================
would run: 2
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "0\n" > expected/exitstatus

(
  cd actual
  shut -n prefix > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
