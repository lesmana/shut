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

printf '\
#! /bin/sh
exit 13
' > mktemp

chmod +x mktemp

(
  cd actual
  set +e
  PATH=$SHUT_TESTPWD:$PATH
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
