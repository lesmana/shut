#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

mkdir -p expected/tempdir

printf "\
./test0
================
would run: 1
" > expected/stdout

printf "\
error deleting tempdir
not fatal but annoying
" > expected/stderr

printf "3\n" > expected/exitstatus

printf '\
#! /bin/sh
echo xxxxxxxxxxxxxxxxxx mktemp >&2
mkdir -p tempdir
echo tempdir
' > mktemp

printf "\
#! /bin/sh
echo xxxxxxxxxxxxxxxxxxx \$* >&2
if [ \"\$*\" = \"-rf tempdir\" ]; then
  chmod -w tempdir/..
  PATH=$PATH rm \"\$@\"
  exitstatus=\$?
  chmod +w tempdir/..
  exit \$exitstatus
else
  PATH=$PATH rm \"\$@\"
fi
" > rm

chmod +x mktemp rm

(
  PATH=$SHUT_TESTPWD:$PATH
  cd actual
  set +e
  shut -n > stdout 2> stderr
  printf "$?\n" > exitstatus
  set -e
)

diff -r expected actual
