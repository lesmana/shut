#! /bin/sh

set -xeu

mkdir -p actual/exactdir actual/exactdirplus

touch actual/exactdir/x actual/exactdir/n actual/exactdirplus/x actual/x

chmod +x actual/exactdir/x actual/exactdirplus/x actual/x

cp -a actual expected

printf "\
./exactdir/x
would run: 1
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut -n exactdir > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
