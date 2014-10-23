#! /bin/sh

set -xeu

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir/test000001

# prepare shutdir

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

printf -- "\
./test0
" > expected/shutdir/testserror

# prepare shut output

printf -- "\
================
ERROR ./test0
error creating workdir
================
error:
./test0
================
run: 1 pass: 0 fail: 0 error: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
1
" > expected/exitstatus

# inject error

realmkdir="$(which mkdir)"

printf -- '#! /bin/sh
if [ "$*" = "workdir" ]; then
  touch workdir
  "%s" "$@"
  exitstatus=$?
  rm workdir
  exit $exitstatus
else
  "%s" "$@"
fi
' "$realmkdir" "$realmkdir" > mkdir

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
