#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p actual/shutdir

printf "\
" > expected/stdout

printf "\
error deleting $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
#! /bin/sh
if [ \"\$*\" = \"-r $PWD/actual/shutdir\" ]; then
  PATH=$PATH rm \"\$@\"
  PATH=$PATH rm \"\$@\"
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

diff -u -r expected actual
