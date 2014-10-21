#! /bin/sh

set -xeu

mkdir -p actual

touch actual/test0

chmod +x actual/test0

cp -a actual expected

printf -- "\
" > expected/stdout

printf -- "\
failed changing directory to loldir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

printf -- '\
#! /bin/sh
touch loldir
echo loldir
' > mktemp

chmod +x mktemp

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

diff -r expected actual
