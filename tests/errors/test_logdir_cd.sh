#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf "\
error changing directory to logdir
" > expected/shutoutput

printf "3\n" > expected/shutexitstatus

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
  shut > shutoutput 2>&1
  printf "$?\n" > shutexitstatus
  set -e
)

diff -r expected actual
