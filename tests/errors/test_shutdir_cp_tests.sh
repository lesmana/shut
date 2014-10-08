#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf "\
" > expected/stdout

printf "\
error copying tests to $SHUT_TESTPWD/actual/shutdir
cannot continue
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"tests $SHUT_TESTPWD/actual/shutdir\" ]; then
  mkdir $SHUT_TESTPWD/actual/shutdir/tests
  PATH=$PATH cp \"\$@\"
  exitstatus=\$?
  rm -rf $SHUT_TESTPWD/actual/shutdir/tests
  exit \$exitstatus
else
  PATH=$PATH cp \"\$@\"
fi
" > cp

chmod +x cp

(
  PATH=$SHUT_TESTPWD:$PATH
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
