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

printf -- '#! /bin/sh
shutdir="%s/actual/shutdir"
realrm="%s"
if [ "$*" = "-r -- $shutdir" ]; then
  "$realrm" "$@"
fi
"$realrm" "$@"
' "$PWD" "$(which rm)" > rm

chmod +x rm

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff ${SHUT_VERBOSE+"-u"} -r expected actual
