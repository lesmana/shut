#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0 actual/test1 actual/nottest

chmod +x actual/test0 actual/test1 actual/nottest

cp -a actual expected

printf "\
./test0
./test1
would run: 2
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
