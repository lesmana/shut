#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
error changing directory to $SHUT_TESTPWD/actual/shutdir
cannot continue
" > expected/shutoutput

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
  shut > shutoutput 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
