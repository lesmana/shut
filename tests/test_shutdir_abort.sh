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
is not shutdir: shutdir
will not overwrite
" > expected/shutoutput

printf "2\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
