#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf "\
error changing directory to testdir
failed tests:
./test0
----------------
run: 1 pass: 0 fail: 1
" > expected/shutoutput

printf "1\n" > expected/shutexitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
" > expected/shutdir/pass

printf "\
./test0
" > expected/shutdir/fail

printf "\
#! /bin/sh
if [ \"\$*\" = \"-p ./test0.dir\" ]; then
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
