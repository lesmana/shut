#! /bin/sh

set -xeu

mkdir -p actual/exactdir actual/exactdirplus

touch actual/exactdir/x actual/exactdir/n actual/exactdirplus/x actual/x

chmod +x actual/exactdir/x actual/exactdirplus/x actual/x

cp -a actual expected

printf "\
./exactdir/x
================
would run: 1
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n exactdir > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
