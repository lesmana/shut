#! /bin/sh

set -xeu

mkdir -p actual/d1

touch actual/test0 actual/d1/test1

chmod +x actual/test0 actual/d1/test1

cp -a actual expected

printf "\
./d1/test1
./test0
would run: 2
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir expected/shutdir

printf "\
./d1/test1
./test0
" > expected/shutdir/tests

(
  cd actual
  set +e
  shut -n > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
