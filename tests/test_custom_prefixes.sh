#! /bin/sh

set -xeu

mkdir -p actual

touch actual/foo1 actual/foo2 actual/bar1 actual/bar2 actual/baz1 actual/baz2

chmod +x actual/*

cp -a actual expected

printf "\
./bar1
./bar2
./foo1
./foo2
would run: 4
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -n foo bar > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
