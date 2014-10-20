#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error creating tempdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# run shut

(
  cd actual
  export TMPDIR=/dev/null
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
