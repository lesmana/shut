#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/logdir/test0.dir

printf "\
================
ERROR ./test0
error creating workdir
================
error:
./test0
================
run: 1 pass: 0 fail: 0 error: 1
" > expected/stdout

printf "\
" > expected/stderr

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
if [ \"\$*\" = \"-p workdir\" ]; then
  touch workdir
  PATH=$PATH mkdir \"\$@\"
  exitstatus=\$?
  rm workdir
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
