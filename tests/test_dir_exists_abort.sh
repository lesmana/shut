#! /bin/sh

set -xeu

mkdir -p actual actual/shutdir

printf "\
#! /bin/sh
set -x
true
" > actual/test0

chmod +x actual/test0

touch actual/shutdir/existingdir

cp -a actual expected

printf "\
name exists: shutdir
will not overwrite
use -f to overwrite
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

(
  cd actual
  set +e
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
