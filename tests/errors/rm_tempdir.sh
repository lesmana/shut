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
================
found:
./test0
================
found: 1
" > expected/stdout

printf -- "\
error deleting tempdir
not fatal but annoying
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
mkdir -p -- "$PWD/tempdir"
printf -- "%%s\\n" "$PWD/tempdir"
' > mktemp

printf -- '#! /bin/sh
realrm="%s"
if [ "$*" = "-r -- $PWD/tempdir" ]; then
  "$realrm" "$@"
fi
"$realrm" "$@"
' "$(which rm)" > rm

chmod +x mktemp rm

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut -n > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff ${SHUT_VERBOSE+"-u"} -r expected actual
