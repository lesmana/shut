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
error creating directory $PWD/actual/shutdir
cannot continue
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

realmkdir="$(which mkdir)"

printf -- '#! /bin/sh
if [ "$*" = "-p -- %s/actual/shutdir" ]; then
  touch -- "%s/actual/shutdir"
  "%s" "$@"
  exitstatus=$?
  rm -- "%s/actual/shutdir"
  exit $exitstatus
else
  "%s" "$@"
fi
' "$PWD" "$PWD" "$realmkdir" "$PWD" "$realmkdir" > mkdir

chmod +x mkdir

# run shut

(
  PATH=$PWD:$PATH
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
