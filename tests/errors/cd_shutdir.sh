#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error changing directory to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-- testsfound $PWD/actual/shutdir\" ]; then
  rm -rf $PWD/actual/shutdir
else
  PATH=$PATH cp \"\$@\"
fi
" > cp

chmod +x cp

# run shut

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
