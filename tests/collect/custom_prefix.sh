#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/prefix0 actual/prefix1 actual/notprefix

chmod +x actual/prefix0 actual/prefix1 actual/notprefix

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
================
found:
./prefix0
./prefix1
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
  shut -n prefix > stdout 2> stderr
  printf -- "$?\n" > exitstatus
)

# compare

diff -r -C 9000 expected actual
