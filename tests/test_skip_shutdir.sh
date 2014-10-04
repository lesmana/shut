#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

touch actual/testtake actual/shutdir/testskip

chmod +x actual/testtake actual/shutdir/testskip

cp -a actual expected

printf "\
./testtake
================
would run: 1
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
