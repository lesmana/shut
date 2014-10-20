#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

# prepare actual

mkdir -p actual/shutdir

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error deleting $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-r -- $PWD/actual/shutdir\" ]; then
  PATH=$PATH rm \"\$@\"
  PATH=$PATH rm \"\$@\"
else
  PATH=$PATH rm \"\$@\"
fi
" > rm

chmod +x rm

# run shut

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
