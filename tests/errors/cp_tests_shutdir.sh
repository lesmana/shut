#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error copying testsfound to $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

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

# run shut

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
