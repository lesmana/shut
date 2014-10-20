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
./test0
================
would run: 1
" > expected/stdout

printf -- "\
error deleting tempdir
not fatal but annoying
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '\
#! /bin/sh
mkdir -p $PWD/tempdir
echo $PWD/tempdir
' > mktemp

printf -- "\
#! /bin/sh
if [ \"\$*\" = \"-r -- \$PWD/tempdir\" ]; then
  PATH=$PATH rm \"\$@\"
  PATH=$PATH rm \"\$@\"
else
  PATH=$PATH rm \"\$@\"
fi
" > rm

chmod +x mktemp rm

# run shut

(
  PATH=$PWD:$PATH
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
