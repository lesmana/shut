#! /bin/sh

set -xeu

mkdir -p actual/shutdir

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
" > expected/stdout

printf "2\n" > expected/exitstatus

(
  cd actual
  set +e
  shut -k > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
