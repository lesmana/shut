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

printf -- '#! /bin/sh
realmkdir="%s"
if [ "$*" = "workdir" ]; then
  touch "workdir"
  "$realmkdir" "$@"
  exitstatus=$?
  rm "workdir"
  exit $exitstatus
else
  "$realmkdir" "$@"
fi
' "$(which mkdir)" > mkdir

chmod +x mkdir

export PATH="$PWD:$PATH"

# run shut

(
  cd actual
  shut > stdout 2> stderr
  printf -- "$?\n" > exitstatus
) || true

# compare

diff -r expected actual
