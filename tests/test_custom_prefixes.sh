#! /bin/sh

set -xeu

mkdir -p actual

touch actual/foo actual/bar actual/baz

chmod +x actual/foo actual/bar actual/baz

cp -a actual expected

printf "\
./foo
./bar
would run: 2
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
