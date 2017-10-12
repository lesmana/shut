#! /bin/sh

# prepare actual

mkdir -p actual

touch actual/test0

chmod +x actual/test0

# prepare expected

cp -a actual expected

mkdir -p expected/shutdir

# prepare shutdir

printf -- "\
./test0
" > expected/shutdir/testsfound

printf -- "\
" > expected/shutdir/testsrun

printf -- "\
" > expected/shutdir/testspass

printf -- "\
" > expected/shutdir/testsfail

# prepare shut output

printf -- "\
" > expected/stdout

printf -- "\
error changing directory to testdir: test000001
" > expected/stderr

printf -- "\
3
" > expected/exitstatus

# inject error

printf -- '#! /bin/sh
realmkdir="%s"
if [ "$*" != "-- test000001" ]; then
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

diff -r expected actual
