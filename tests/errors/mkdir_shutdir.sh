#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf -- "\
" > expected/stdout

printf -- "\
error creating directory $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-p -- $PWD/actual/shutdir\" ]; then
  touch $PWD/actual/shutdir
  PATH=$PATH mkdir \"\$@\"
  exitstatus=\$?
  rm $PWD/actual/shutdir
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
