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

realrm="$(which rm)"

printf -- '#! /bin/sh
if [ "$*" = "-r -- %s/actual/shutdir" ]; then
  "%s" "$@"
fi
"%s" "$@"
' "$PWD" "$realrm" "$realrm" > rm

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
