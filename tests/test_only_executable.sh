#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test_exec actual/test_notexec

chmod +x actual/test_exec

cp -a actual expected

printf "\
./test_exec
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
