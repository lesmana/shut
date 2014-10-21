#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf -- "\
" > expected/stdout

printf -- "\
error changing directory to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-- testsfound $PWD/actual/shutdir\" ]; then
  rm -rf $PWD/actual/shutdir
else
  PATH=$PATH cp \"\$@\"
fi
" > cp

chmod +x cp

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
