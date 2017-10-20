#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test1

chmod +x actual/test1

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir

# prepare shutdir

printf -- "\
./test1
" > expected/shutdir/testsfound

printf -- "\
./test1
" > expected/shutdir/testsrun

printf -- "\
./test1
" > expected/shutdir/testserror

printf -- "\
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
================
TEST ./test1
stdout:
stderr:
  error creating testdir: ./test1
ERROR ./test1
================
error:
./test1
================
found: 1 run: 1 pass: 0 fail: 0 error: 1
" > expected/stdout

printf -- "\
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
realmkdir="%s"
if [ "$*" = "-p -- ./test1" ]; then
  touch "./test1"
  "$realmkdir" "$@"
  exitstatus=$?
  rm "./test1"
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
)

# compare

diff -r -C 9000 expected actual
