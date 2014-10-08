#! /bin/sh

set -xeu

mkdir -p actual/shutdir

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf "\
" > expected/stdout

printf "\
error deleting $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"-rf $PWD/actual/shutdir\" ]; then
  chmod -w $PWD/actual
  PATH=$PATH rm \"\$@\"
  exitstatus=\$?
  chmod +w $PWD/actual
  exit \$exitstatus
else
  PATH=$PATH rm \"\$@\"
fi
" > rm

chmod +x rm

(
  PATH=$PWD:$PATH
  cd actual
  set +e
  shut > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
