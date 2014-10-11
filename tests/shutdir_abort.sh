#! /bin/sh

set -xeu

mkdir -p actual

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

touch actual/shutdir

cp -a actual expected

printf "\
" > expected/stdout

printf "\
is not shutdir: shutdir
will not overwrite
" > expected/stderr

printf "2\n" > expected/exitstatus

(
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -u -r expected actual