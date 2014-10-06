#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
error creating tempdir
cannot continue
" > expected/stdout

printf "3\n" > expected/exitstatus

(
  cd actual
  set +e
  export TMPDIR=/dev/null
  shut > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
