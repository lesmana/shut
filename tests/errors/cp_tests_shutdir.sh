#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf -- "\
" > expected/stdout

printf -- "\
error copying testsfound to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "3\n" > expected/exitstatus

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-- testsfound $PWD/actual/shutdir\" ]; then
  mkdir $PWD/actual/shutdir/testsfound
  PATH=$PATH cp \"\$@\"
  exitstatus=\$?
  rm -rf $PWD/actual/shutdir/testsfound
  exit \$exitstatus
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
