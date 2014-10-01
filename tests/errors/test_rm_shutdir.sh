#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
error deleting $SHUT_TESTPWD/actual/shutdir
cannot continue
" > expected/shutoutput

printf "3\n" > expected/shutexitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"-rf $SHUT_TESTPWD/actual/shutdir\" ]; then
  exit 23
else
  PATH=$PATH rm \"\$@\"
fi
" > rm

chmod +x rm

(
  cd actual
  set +e
  PATH=$SHUT_TESTPWD:$PATH
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
