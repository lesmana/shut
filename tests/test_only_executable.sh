#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test_exec actual/test_notexec

chmod +x actual/test_exec

cp -a actual expected

printf "\
./test_exec
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
