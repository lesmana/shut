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
" > expected/stdout

printf "0\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -n > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
