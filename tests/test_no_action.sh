#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0 actual/test1

chmod +x actual/test0 actual/test1

cp -a actual expected

printf "\
./test0
./test1
================
would run: 2
" > expected/shutoutput

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
