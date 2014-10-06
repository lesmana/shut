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
" > expected/shutoutput

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n exactname > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
