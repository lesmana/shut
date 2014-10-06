#! /bin/sh

set -xeu

mkdir -p actual

touch actual/exactname actual/exactnameplusextra actual/othername

chmod +x actual/*

cp -a actual expected

printf "\
./exactname
================
would run: 1
" > expected/stdout

printf "\
" > expected/stderr

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n exactname > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
