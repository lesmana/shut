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

realcp="$(which cp)"

printf -- '#! /bin/sh
if [ "$*" = "-- testsfound %s/actual/shutdir" ]; then
  rm -rf -- "%s/actual/shutdir"
else
  "%s" "$@"
fi
' "$PWD" "$PWD" "$realcp" > cp

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
