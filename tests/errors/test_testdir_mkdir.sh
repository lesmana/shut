#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir

printf "\
error creating testdir
================
error:
./test0
================
run: 1 pass: 0 fail: 0 error: 1
" > expected/shutoutput

printf "1\n" > expected/exitstatus

printf "\
./test0
" > expected/shutdir/tests

printf "\
" > expected/shutdir/pass

printf "\
" > expected/shutdir/fail

printf "\
./test0
" > expected/shutdir/error

printf "\
#! /bin/sh
if [ \"\$*\" = \"-p ./test0.dir\" ]; then
  touch ./test0.dir
  PATH=$PATH mkdir \"\$@\"
  exitstatus=\$?
  rm ./test0.dir
  exit \$exitstatus
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
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
