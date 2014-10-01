#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
error creating tempdir
cannot continue
" > expected/shutoutput

printf "3\n" > expected/shutexitstatus

(
  cd actual
  set +e
  export TMPDIR=/dev/null
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
