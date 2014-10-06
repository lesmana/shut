#! /bin/sh

set -xeu

mkdir -p actual

touch actual/prefix0 actual/prefix1 actual/notprefix

chmod +x actual/prefix0 actual/prefix1 actual/notprefix

cp -a actual expected

printf "\
./prefix0
./prefix1
================
would run: 2
" > expected/shutoutput

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n prefix > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
