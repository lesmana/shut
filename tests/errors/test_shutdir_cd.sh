#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
" > expected/stdout

printf "\
error changing directory to $SHUT_TESTPWD/actual/shutdir
cannot continue
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"tests $SHUT_TESTPWD/actual/shutdir\" ]; then
  rm -rf $SHUT_TESTPWD/actual/shutdir
else
  PATH=$PATH cp \"\$@\"
fi
" > cp

chmod +x cp

(
  cd actual
  set +e
  PATH=$SHUT_TESTPWD:$PATH
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
