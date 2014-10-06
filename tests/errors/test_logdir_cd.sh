#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf "\
error changing directory to logdir
" > expected/stdout

printf "3\n" > expected/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
#! /bin/sh
if [ \"\$*\" = \"-p logdir\" ]; then
  :
else
  PATH=$PATH mkdir \"\$@\"
fi
" > mkdir

chmod +x mkdir

(
  cd actual
  set +e
  PATH=$SHUT_TESTPWD:$PATH
  shut > stdout 2>&1
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
