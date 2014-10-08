#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
" > expected/stdout

printf "\
error creating directory $SHUT_TESTPWD/actual/shutdir
cannot continue
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"-p $SHUT_TESTPWD/actual/shutdir\" ]; then
  touch $SHUT_TESTPWD/actual/shutdir
  PATH=$PATH mkdir \"\$@\"
  exitstatus=\$?
  rm $SHUT_TESTPWD/actual/shutdir
  exit \$exitstatus
else
  PATH=$PATH mkdir \"\$@\"
fi
" > mkdir

chmod +x mkdir

(
  PATH=$SHUT_TESTPWD:$PATH
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
