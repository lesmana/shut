#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir/test000001

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

printf -- "\
./test0
" > expected/shutdir/testserror

printf -- "\
================
ERROR ./test0
error creating workdir
================
error:
./test0
================
run: 1 pass: 0 fail: 0 error: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
1
" > expected/exitstatus

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"workdir\" ]; then
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
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
