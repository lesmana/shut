#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/shutdir

printf "\
" > expected/stdout

printf "\
error creating logdir
" > expected/stderr

printf "3\n" > expected/exitstatus

printf "\
./test0
" > expected/shutdir/tests


printf "\
#! /bin/sh
if [ \"\$*\" = \"-p logdir\" ]; then
  touch logdir
  PATH=$PATH mkdir \"\$@\"
  exitstatus=\$?
  rm logdir
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
