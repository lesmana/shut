#! /bin/sh

set -xeu

mkdir actual

touch actual/test0 actual/test1 actual/test2

chmod +x actual/test1 actual/test2

cp -a actual expected

printf "\
./test1
./test2
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
