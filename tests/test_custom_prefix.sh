#! /bin/sh

set -xeu

mkdir actual

touch actual/prefix0 actual/prefix1 actual/prefix2

chmod +x actual/prefix0 actual/prefix1 actual/prefix2

cp -a actual expected

printf "\
./prefix0
./prefix1
./prefix2
would run: 3
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

mkdir -p expected/shutdir

(
  cd actual
  set +e
  shut -n prefix > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
