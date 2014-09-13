#! /bin/sh

set -xeu

mkdir actual

touch actual/prefix0 actual/prefix1 actual/notprefix

chmod +x actual/prefix0 actual/prefix1 actual/notprefix

cp -a actual expected

mkdir expected/shutdir

printf "\
./prefix0
./prefix1
would run: 2
" > expected/shutoutput

printf "0\n" > expected/shutexitstatus

printf "\
./prefix0
./prefix1
" > expected/shutdir/mktempfilename

(
  cd actual
  set +e
  shut -n prefix > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
